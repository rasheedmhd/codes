fn main() -> Result<(), std::io::Error> {
    let paths = ["sample4.txt"];

    // check all documents
    let mut results = vec![];
    for path in &paths {
        let result = check(path)?;
        results.push(result);
    }

    // report them all
    for result in results {
        report(result);
    }

    Ok(())
}

fn report(result: Option<Mistake>) {
    if let Some(mistake) = result {
        println!("{}", mistake);
    }
}

struct Mistake {
    path: &'static str,

    text: String,
    locations: Vec<usize>,
}

use std::io::Error as E;

fn check(path: &'static str) -> Result<Option<Mistake>, E> {
    let text = std::fs::read_to_string(path)?;

    let locations: Vec<_> = text.match_indices(",").map(|(index, _)| index).collect();

    Ok(if locations.is_empty() {
        None
    } else {
        Some(Mistake {
            path,
            text,
            locations,
        })
    })
}

use std::fmt;

impl Mistake {
    fn line_bounds(&self, index: usize) -> (usize, usize) {
        let len = self.text.len();

        let before = &self.text[..index];
        let start = before.rfind("\n").map(|x| x + 1).unwrap_or(0);

        let after = &self.text[index + 1..];
        let end = after.find("\n").map(|x| x + index + 1).unwrap_or(len);

        (start, end)
    }
}

impl fmt::Display for Mistake {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for &location in &self.locations {
            let (start, end) = self.line_bounds(location);
            let line = &self.text[start..end];

            let line_number = self.text[..start].matches("\n").count() + 1;
            let comma_index = location - start;

            write!(f, "{}: commas are forbidden:\n\n", self.path)?;

            // print the line, with line number
            write!(f, "{:>8} | {}\n", line_number, line)?;

            // indicate where the comma is
            write!(f, "{}^\n\n", " ".repeat(11 + comma_index))?;
        }
        Ok(())
    }
}
