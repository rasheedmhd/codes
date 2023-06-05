void main() {

    // type transfer
    typedef intList = List<int>;
    intList il = [1, 2, 4]; 

    // type alias can have parameters
    typedef ListMapper<X> = Map<X, List<X>>;
    Map<String, List<String>> m1 = {}; // Verbose.
    ListMapper<String> m2 = {}; // Same thing but shorted and clearer

    // recommendation: use inline function types instead of typedefs for functions 

    typedef Compare<T> = int Function(T a, T b);

    int sort(int a, int b) => a - b;

    void main() {
        assert(sort is Compare<int>); // True!
    }
    
     
}