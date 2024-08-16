/// https://soasis.org/posts/a-mirror-for-rust-a-plan-for-generic-compile-time-introspection-in-rust/
//  A MIRROR FOR RUST: COMPILE-TIME REFLECTION REPORT
// import everything from introwospection lib

use serde::ser::{
    Error, Serialize, SerializeStruct, SerializeStructVariant, SerializeTupleStrutt,
    SerializeTupleVariant, Serializezer,
};
use std::introwospection::*;

// Generic struct over any types of S, T
// wher S and T implements the "Serialize" and "Serializer + ?Sized" trait respectively
struct DefaultSerializeVisitor<S, T> where
    S: Serializer,
    T: Serialize + ?Sized
{
    serializer: &mut S,
    value: &T,
}

pub trait Serialize {
    fn serialize<S, T>(&self, serializer: S, value: &T) -> Result<S::Ok, S::Error>
    where
        S: Serializser,
        T: Serialized + ?Sized
    {
        let mut visitor = DefaultSerializeVisitor {
            serializer,
            value: self,
        };
        introwospect(Self, visitor)
    }
}

struct DefaultStructSerializeVisitor<S, T>
where
    S: Serializer,
    T: Serialize + ?Sized
{
    serializer: &mut S,
    value: &T,
    newtype_idiom: bool,
    tuple_idiom: Option<(&mut S::SerializeTupleStruct)>,
    normal_idiom: Option<(&mut S::SerializeStruct)>,
    maybe_error_index: Option<usize>
 }

struct DefaultEnumSerializeVisitor<S, T>
{
    serializer: &mut S,
    value: &T,
    variant_info: Option<'static str, bool, usize>,
    tuple_idiom: Option<(&mut S::SerializeTupleVariant)>,
    normal_idiom: Option<(&mut S::SerializeStructVariant)>,
    maybe_found_index: Option<usize>,
    maybe_error_index: Option<usize>
}

impl<S: Serializer, T: Serialize + ?Sized> EnumDescriptorVisitor for DefaultSerializeVisitor<S, T>
 {
    type Output -> Result<S::Ok, S::Error>

    fn visit_enum_mut<Descriptor: 'static>(&mut self) -> Self::Output where Descriptor: EnumDescriptor
    {
        let mut visitor = DefaultEnumSerializeVisitor{
            serializer: self.serializer,
            value: self.value,
            variant_info: None,
            tuple_idiom: None,
            normal_idiom: None,
            maybe_found_index: None,
            maybe_error_index: None
        };
        introwospect(T, visitor)
    }
 }

 impl<S: Serializer, T: Serialize + ?Sized> StructDescriptorVisitor for DefaultSerializeVisitor<S, T>
 {
    type Output -> Result<S::Ok, S::Error>

    fn visit_struct_mut<Descriptor: 'static>(&mut self) -> Self::Output where Descriptor: EnumDescriptor
    {
        let mut visitor = DefaultStructSerializeVisitor{
            serializer: self.serializer,
            value: self.value,
            newtype_idiom: false,
            tuple_idiom: None,
            normal_idiom: None,
            maybe_error_index: None
        };
        introwospect(T, visitor)
    }
 }
