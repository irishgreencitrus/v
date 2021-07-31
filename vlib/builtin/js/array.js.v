module builtin

struct array {
	arr JS.Array
pub:
	len int
	cap int
}

#function flatIntoArray(target, source, sourceLength, targetIndex, depth) {
#"use strict";
#
#for (var sourceIndex = 0; sourceIndex < sourceLength; ++sourceIndex) {
#if (sourceIndex in source) {
#var element = source[sourceIndex];
#if (depth > 0 && Array.isArray(element))
#targetIndex = flatIntoArray(target, element, element.length, targetIndex, depth - 1);
#else {
#target[targetIndex] = element;
#++targetIndex;
#}
#}
#}
#return targetIndex;
#}
#function flatArray(target,depth) {
#var array = target
#var length = array.length;
#var depthNum = 1;
#
#if (depth !== undefined)
#depthNum = +depth
#
#var result = []
#
#flatIntoArray(result, array, length, 0, depthNum);
#return result;
#}

[unsafe]
pub fn (a array) repeat_to_depth(count int, depth int) array {
	if count < 0 {
		panic('array.repeat: count is negative: $count')
	}
	mut arr := empty_array()
	#let tmp = new Array(a.arr.length * +count);
	#tmp.fill(a.arr);
	#
	#arr.arr = flatArray(tmp,depth+1);

	return arr
}

// last returns the last element of the array.
pub fn (a array) last() voidptr {
	mut res := voidptr(0)
	#res = a.arr[a.len-1];

	return res
}

fn (a array) get(ix int) voidptr {
	mut result := voidptr(0)
	#result = a.arr[ix]

	return result
}

pub fn (a array) repeat(count int) array {
	unsafe {
		return a.repeat_to_depth(count, 0)
	}
}

fn empty_array() array {
	mut arr := array{}
	#arr = new array([])

	return arr
}

fn (a &array) set_len(i int) {
	#a.arr.length=i
}

pub fn (mut a array) sort_with_compare(compare voidptr) {
	#a.arr.sort(compare)
}

pub fn (mut a array) sort() {
	#a.arr.sort()
}

pub fn (a array) index(v string) int {
	for i in 0 .. a.len {
		#if (a.arr[i].toString() == v.toString())

		{
			return i
		}
	}
	return -1
}

pub fn (a array) slice(start int, end int) array {
	mut result := a
	#result = new array(a.arr.slice(start,end))

	return result
}

pub fn (mut a array) insert(i int, val voidptr) {
	#a.arr.splice(i,0,val)
}

pub fn (mut a array) insert_many(i int, val voidptr, size int) {
	#a.arr.splice(i,0,...val.slice(0,+size))
}

pub fn (mut a array) join(separator string) string {
	mut res := ''
	#res = new builtin.string(a.arr.join(separator +''));

	return res
}

fn (a array) push(val voidptr) {
	#a.arr.push(val)
}

pub fn (a array) str() string {
	mut res := ''
	#res = new builtin.string(a + '')

	return res
}

#array.prototype[Symbol.iterator] = function () { return this.arr[Symbol.iterator](); }
#array.prototype.entries = function () { return this.arr.entries(); }
#array.prototype.map = function(callback) { return this.arr.map(callback); }
#array.prototype.filter = function(callback) { return new array(this.arr.filter( function (it) { return (+callback(it)) != 0; } )); }
#Object.defineProperty(array.prototype,'cap',{ get: function () { return this.len; } })
// delete deletes array element at index `i`.
pub fn (mut a array) delete(i int) {
	a.delete_many(i, 1)
}

// delete_many deletes `size` elements beginning with index `i`
pub fn (mut a array) delete_many(i int, size int) {
	#a.arr.splice(i.valueOf(),size.valueOf())
}

// prepend prepends one value to the array.
pub fn (mut a array) prepend(val voidptr) {
	a.insert(0, val)
}

// prepend_many prepends another array to this array.
[unsafe]
pub fn (mut a array) prepend_many(val voidptr, size int) {
	unsafe { a.insert_many(0, val, size) }
}

pub fn (a array) reverse() array {
	mut res := array{}
	#res.arr = Array.from(a.arr).reverse()

	return res
}

#array.prototype.$includes = function (elem) { return this.arr.find(function(e) { return vEq(elem,e); }) !== undefined;}

// reduce executes a given reducer function on each element of the array,
// resulting in a single output value.
pub fn (a array) reduce(iter fn (int, int) int, accum_start int) int {
	mut accum_ := accum_start
	#for (let i of a)  {
	#accum_ = iter(accum_, a.arr[i])
	#}

	return accum_
}