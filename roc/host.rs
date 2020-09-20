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
    let filename = "../unsorted.csv";

    let file = File::open(filename.clone()).expect("error loading '../unsorted.csv'");

    let mut contents = String::new();
    let mut buf_reader = BufReader::new(file);

    buf_reader
        .read_to_string(&mut contents)
        .expect("error reading file to string");

    let nums = contents
        .split(",")
        .map(|string| {
            string.trim().parse::<f64>().unwrap_or_else(|err| {
                panic!("Invalid number: {:?} - error was: {:?}", string, err)
            })
        })
        .collect::<Vec<f64>>();

    let nums: Box<[f64]> = nums.into();

    println!("Running Roc quicksort on {} numbers...", nums.len());
    let start_time = SystemTime::now();
    let answer = unsafe { quicksort(nums) };
    let end_time = SystemTime::now();
    let duration = end_time.duration_since(start_time).unwrap();

    // hardcode test output, so stdout is not swamped
    println!(
        "Roc quicksort took {:.4} ms to compute this answer: {:?}",
        duration.as_secs_f64() * 1000.0,
        // truncate the answer, so stdout is not swamped
        &answer[0..20]
    );

    // the pointer is to the first _element_ of the list,
    // but the refcount precedes it. Thus calling free() on
    // this pointer would segfault/cause badness. Therefore, we
    // leak it for now
    Box::leak(answer);
}
