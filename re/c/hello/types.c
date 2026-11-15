// 
// Enums
// 
enum week { monday, tuesday, wednesday, thursday, friday, saturday, sunday };
enum cardinal_points { north = 0, east = 90, south = 180, west = 270 };
enum months { january = 1, february, march, april, may, june, july, august, september, october, november, december };

// Enums with underlying types
enum a: unsigned long long { 
    a1 = 0xFFFFFFFFFFFFFFFFULL
};

// Floats 
float, double, long double;

// Real floating types

// Decimal floating types
_Decimal128, _Decimal32, _Decimal64;
decimal32, decimal64, decimal128;

// Complex floating types
_Complex float, _Complex double, _Complex long double;
