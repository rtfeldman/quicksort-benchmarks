#![allow(non_snake_case)]

use roc_std::{RocCallResult, RocList};
use std::alloc::Layout;
use std::env;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::process;
use std::time::SystemTime;

extern "C" {
    #[link_name = "roc__mainForHost_1_exposed"]
    fn quicksort(list: RocList<f64>, output: &mut RocCallResult<RocList<f64>>) -> ();
}

#[no_mangle]
pub fn rust_main() -> isize {
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
            string
                .trim()
                .parse::<f64>()
                .unwrap_or_else(|err| panic!("Invalid number: {:?} - error was: {:?}", string, err))
        })
        .collect::<Vec<f64>>();

    let nums = RocList::from_slice(&nums);
    use std::mem::MaybeUninit;
    let mut output = MaybeUninit::uninit();
    let output_ptr = unsafe { &mut *output.as_mut_ptr() };
    let start_time = SystemTime::now();
    unsafe {
        quicksort(nums, output_ptr);
    }
    let end_time = SystemTime::now();
    let duration = end_time.duration_since(start_time).unwrap();
    let answer = unsafe {
        match output.assume_init().into() {
            Ok(value) => value,
            Err(msg) => panic!("roc failed with message {}", msg),
        }
    };

    println!(
        "Finished quicksorting {} numbers in {:.3}ms",
        answer.len(),
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
            string
                .trim()
                .parse::<f64>()
                .unwrap_or_else(|err| panic!("Invalid number: {:?} - error was: {:?}", string, err))
        })
        .collect::<Vec<f64>>();

    if sorted_nums[0..] != answer.as_slice()[0..] {
        println!("Quicksort did not produce the expected sorted numbers!");
    }

    // Exit code
    0
}
