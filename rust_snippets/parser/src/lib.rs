// A parser for a simplified version of XML
// <parent-element>
//      <single-element attribute="attribute_value"/>
// </parent-element>

#[derive(Debug, Clone, PartialEq, Eq)]
struct Element {
    name: String,
    attributes: Vec<(String, String)>,
    children: Vec<Element>,
}

// Fn(Input) -> Result<(Input, Output), Error>
// Fn(&str) -> Result<(&str, Element), &str>

// First Parser
// looks at the first letter and see if it is a
fn the_letter_a(input: &str) -> Result<(&str, ()), &str> {
    match input.chars().next() {
        Some('a') => Ok((&input['a'.len_utf8()..], ())),
        _ => Err(input),
    }
}

// A Parser Builder
fn match_literal(expected: &'static str) -> impl Fn(&str) -> Result<(&str, ()), &str> {
    move |input| match input.get(0..expected.len()) {
        Some(next) if next == expected => Ok((&input[expected.len()..], ())),
        _ => Err(input),
    }
}

// fn main() {
//     // fn letter_a(input: &str) -> Result<(&str, Element), &str> {
//     //     let input = input;
//     //     let first_letter = input.slice[0];
//     //     if let first_letter = "a" {
//     //         println!("The first letter matches "a", {first_letter}");
//     //         Some(first_letter)
//     //     } else {
//     //         input
//     //     }
//     // }
//     //

//     // let sample_input = "aberkewitz";
//     // let sample_name = "yaw";

//     // letter_a(sample_name);
// }
//
//
// Parser Testing
#[test]
fn literal_parser() {
    let parse_joe = match_literal("Hello Joe!");
    assert_eq!(Ok(("", ())), parse_joe("Hello Joe!"));
    assert_eq!(
        Ok((" Hello Robert!", ())),
        parse_joe("Hello Joe! Hello Robert!")
    );
    assert_eq!(Err("Hello Mike!"), parse_joe("Hello Mike!"));
}

fn identifier(input: &str) -> Result<(&str, String), &str> {
    let mut matched = String::new();
    let mut chars = input.chars();

    match chars.next() {
        Some(next) if next.is_alphabetic() => matched.push(next),
        _ => return Err(input),
    }

    while let Some(next) = chars.next() {
        if next.is_alphanumeric() || next == '-' {
            matched.push(next);
        } else {
            break;
        }
    }

    let next_index = matched.len();
    Ok((&input[next_index..], matched))
}

#[test]
fn identifier_parser() {
    assert_eq!(
        Ok(("", "i-am-an-identifier".to_string())),
        identifier("i-am-an-identifier")
    );
    assert_eq!(
        Ok((" entirely an identifier", "not".to_string())),
        identifier("not entirely an identifier")
    );
    assert_eq!(
        Err("!not at all an identifier"),
        identifier("!not at all an identifier")
    );
}
