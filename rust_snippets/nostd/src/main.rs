#![no_std]
#![no_main]

// run with cargo run --target thumbv7em-none-eabihf
// to avoid the compiler complaining about linker errors

// You can set panic to "abort" in the build and release profiles
// in the Cargo.toml for the same effect
use core::panic::PanicInfo;


pub extern "C" fn _start() -> ! {
	loop {}
}


#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
	loop {}
}
