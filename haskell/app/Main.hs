{-# LANGUAGE BangPatterns, ScopedTypeVariables #-}
module Main where
import           Control.Monad.Primitive
import           Control.Applicative ((<$>))
import qualified Data.Vector.Unboxed as V
import qualified Data.Vector.Unboxed.Mutable as M
import           System.Environment (getArgs)
import           System.Clock
import           System.Exit (exitFailure, exitSuccess)
import           Control.DeepSeq (deepseq)
import qualified Data.ByteString as BS
import           Data.ByteString.Char8 (readInt)

partition :: (PrimMonad m, Ord a, M.Unbox a) => Int -> M.MVector (PrimState m) a -> m Int
partition !pi !v = do
    pv <- M.unsafeRead v pi
    M.unsafeSwap v pi lastIdx
    pi' <- go pv 0 0
    M.unsafeSwap v pi' lastIdx
    return pi'
  where
    !lastIdx = M.length v - 1

    go !pv i !si | i < lastIdx =
       do iv <- M.unsafeRead v i
          if iv < pv
            then M.unsafeSwap v i si >> go pv (i+1) (si+1)
            else go pv (i+1) si
    go _   _ !si                = return si

qsort :: (PrimMonad m, Ord a, M.Unbox a) => M.MVector (PrimState m) a -> m ()
qsort v | M.length v < 2 = return ()
qsort v                    = do
    let !pi = M.length v `div` 2
    pi' <- partition pi v
    qsort (M.unsafeSlice 0 pi' v)
    qsort (M.unsafeSlice (pi'+1) (M.length v - (pi'+1)) v)

readFloat :: BS.ByteString -> Maybe ( Float, BS.ByteString )
readFloat bs = (\( value, rest ) -> ( fromIntegral value, rest )) <$> readInt bs

main :: IO ()
main = do
    args <- getArgs
    if length args < 2
      then putStrLn "Usage: qsort RUNS FILENAME" >> exitFailure
      else return ()
    -- let (nRuns::Int) = read (args !! 0)
    let (nRuns::Int) = 2


    nums <- V.unfoldr (\s -> readFloat $ BS.dropWhile isWs s) <$> BS.readFile (args !! 0)


    loop nRuns (do nums' <- V.thaw nums
                   start <- getTime ProcessCPUTime
                   qsort nums'
                   time <- (\x -> x - start) <$> (getTime ProcessCPUTime)
                   putStrLn $ show $ (* 1000) $ fromIntegral (sec time) +
                                     ((fromIntegral $ nsec time) / 1000000000))


    exitSuccess
  where
    loop 0 _ = return ()
    loop n a = a >> loop (n-1) a

    -- isWs !c = c == 10 || c == 20 || c == 9
    isWs !c = c == 44 {- `,` -} 
