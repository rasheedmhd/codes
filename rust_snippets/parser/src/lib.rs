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

// fn pair<P1, P2, R1, R2>(parser1: P1, parser2: P2) -> impl Fn(&str) -> Result<(&str, (R1, R2)), &str>
// where
//     P1: Fn(&str) -> Result<(&str, R1), &str>,
//     P2: Fn(&str) -> Result<(&str, R2), &str>,
// {
//     move |input| match parser1(input) {
//         Ok((next_input, result1)) => match parser2(next_input) {
//             Ok((final_input, result2)) => Ok((final_input, (result1, result2))),
//             Err(err) => Err(err),
//         },
//         Err(err) => Err(err),
//     }
// }

#[test]
fn pair_combinator() {
    let tag_opener = pair(match_literal("<"), identifier);
    assert_eq!(
        Ok(("/>", ((), "my-first-element".to_string()))),
        tag_opener("<my-first-element/>")
    );
    assert_eq!(Err("oops"), tag_opener("oops"));
    assert_eq!(Err("!oops"), tag_opener("<!oops"));
}

// Enter the Functor
// fn map<P, F, A, B>(parser: P, map_fn: F) -> impl Fn(&str) -> Result<(&str, B), &str>
// where
//     P: Fn(&str) -> Result<(&str, A), &str>,
//     F: Fn(A) -> B,
// {
//     // move |input| match parser(input) {
//     //     Ok((next_input, result)) => Ok((next_input, map_fn(result))),
//     //     Err(err) => Err(err),
//     // }

//     move |input| parser(input).map(|(next_input, result)| (next_input, map_fn(result)))
// }

// A type alias
type ParseResult<'a, Output> = Result<(&'a str, Output), &'a str>;

trait Parser<'a, Output> {
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output>;
}

impl<'a, F, Output> Parser<'a, Output> for F
where
    F: Fn(&'a str) -> ParseResult<Output>,
{
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output> {
        self(input)
    }
}

// Rewriting the map function
fn map<'a, P, F, A, B>(parser: P, map_fn: F) -> impl Parser<'a, B>
where
    P: Parser<'a, A>,
    F: Fn(A) -> B,
{
    move |input| {
        parser
            .parse(input)
            .map(|(next_input, result)| (next_input, map_fn(result)))
    }
}

// Rewriting the pair function
// tidying up pair
fn pair<'a, P1, P2, R1, R2>(parser_one: P1, parser_two: P2) -> impl Parser<'a, (R1, R2)>
where
    P1: Parser<'a, R1>,
    P2: Parser<'a, R2>,
{
    move |input| {
        parser_one
            .parse(input)
            .and_then(|(next_input, result_one)| {
                parser_two
                    .parse(next_input)
                    .map(|(last_input, result_two)| (last_input, (result_one, result_two)))
            })
    }
}
