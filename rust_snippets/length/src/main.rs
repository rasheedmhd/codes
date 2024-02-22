use unicode_segmentation::UnicodeSegmentation;
use unic_segment::Graphemes;

fn main() {
	let s = "🤦🏼‍♂️";
	println!("{}", s.graphemes(true).count());
	println!("{}", s.chars().count());
	println!("{}", s.encode_utf16().count());
	println!("{}", s.len());
	println!("after use unic_segment::Graphemes");
	let s = "🤦🏼‍♂️";
	println!("{}", Graphemes::new(s).count());
	println!("{}", s.chars().count());
	println!("{}", s.encode_utf16().count());
	println!("{}", s.len());
}
