use std::env;
use std::process;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::time::SystemTime;

#[link(name = "roc_app", kind = "static")]
extern "C" {
    #[allow(improper_ctypes)]
    #[link_name = "quicksort#1"]
    fn quicksort(list: Box<[f64]>) -> Box<[f64]>;
}

pub fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        println!("This program takes 2 arguments: the file of unsorted comma-separated numbers, and the file of sorted numbers.");
        process::exit(1);
    }
    let unsorted_file = File::open(args[1].clone()).expect("error loading unsorted file");

    let mut contents = String::new();
    let mut buf_reader = BufReader::new(unsorted_file);

    buf_reader
        .read_to_string(&mut contents)
        .expect("error reading unsorted file to string");

    let nums = contents
        .split(",")
        .map(|string| {
            string.trim().parse::<f64>().unwrap_or_else(|err| {
                panic!("Invalid number: {:?} - error was: {:?}", string, err)
            })
        })
        .collect::<Vec<f64>>();

    let nums: Box<[f64]> = nums.into();

    let start_time = SystemTime::now();
    let answer = unsafe { quicksort(nums) };
    let end_time = SystemTime::now();
    let duration = end_time.duration_since(start_time).unwrap();

    // hardcode test output, so stdout is not swamped
    println!(
	    "Finished quicksorting {} numbers in {:.3}ms", answer.len(), 
        duration.as_secs_f64() * 1000.0
    );

    let sorted_file = File::open(args[2].clone()).expect("error loading sorted file");

    let mut contents = String::new();
    let mut buf_reader = BufReader::new(sorted_file);
    buf_reader
        .read_to_string(&mut contents)
        .expect("error reading sorted file to string");

    let sorted_nums = contents
        .split(",")
        .map(|string| {
            string.trim().parse::<f64>().unwrap_or_else(|err| {
                panic!("Invalid number: {:?} - error was: {:?}", string, err)
            })
        })
        .collect::<Vec<f64>>();

    if sorted_nums[0..] != answer[0..] {
        println!("Quicksort did not produce the expected sorted numbers!");
    }
    // the pointer is to the first _element_ of the list,
    // but the refcount precedes it. Thus calling free() on
    // this pointer would segfault/cause badness. Therefore, we
    // leak it for now
    Box::leak(answer);
}
