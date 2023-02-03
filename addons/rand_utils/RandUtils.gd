tool
class_name RandUtils extends Resource

# Partial implementation of python's string constants: https://docs.python.org/3/library/string.html
const ASCII_LETTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const ASCII_LOWERCASE = "abcdefghijklmnopqrstuvwxyz"
const ASCII_UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const ASCII_DIGITS = "0123456789"
const ASCII_PUNCTUATION =  "!\"#$%&'()*+, -./:;<=>?@[\\]^_`{|}~"

## Returns a boolean based on a probability
static func bool(probability: float = .5) -> bool:
	randomize()

	return bool(randf() < 1 - probability)

## Returns a normalized Vector2
static func vec2() -> Vector2:
	randomize()

	return Vector2(randf(), randf())

## Returns a normalized Vector3
static func vec3() -> Vector3:
	randomize()

	return Vector3(randf(), randf(), randf())

## Returns a random string containing letters with a given length
static func letters(length: int = 1, unique: bool = false) -> String:
	return from_string(ASCII_LETTERS, length, unique)

## Returns a random string containing alphanumeric characters with a given length
static func alphanumeric(length: int = 1, unique: bool = false) -> String:
	return from_string(ASCII_LETTERS + ASCII_DIGITS, length, unique)

## Returns a random string containing alphanumeric characters with a given length. Letters are lowercase
static func alphanumeric_simple(length: int = 1, unique: bool = false) -> String:
	return from_string(ASCII_LOWERCASE + ASCII_DIGITS, length, unique)

## Returns a random string containing ASCII characters with a given length.
static func string(length: int = 1, unique: bool = false) -> String:
	return from_string(ASCII_LETTERS + ASCII_DIGITS + ASCII_PUNCTUATION, length, unique)

## Returns a random string from a given length and string characters
static func from_string(string, length: int = 1, unique: bool = false) -> String:
	var array: PoolByteArray = from_array(string.to_utf8(), length, unique)
	return array.get_string_from_utf8()


## Returns a Color instance with randomized properties
static func color(hueMin: float = 0, hueMax: float = 1, saturationMin: float = 0, saturationMax: float = 1, valueMin: float = 0, valueMax: float = 1, alphaMin: float = 1, alphaMax: float = 1) -> Color:
	randomize()
	var opaque = alphaMin == alphaMax

	return Color.from_hsv(rand_range(hueMin, hueMax), rand_range(saturationMin, saturationMax), rand_range(valueMin, valueMax), 1.0 if opaque else rand_range(alphaMin, alphaMax))

## Returns a random byte (int)
static func byte() -> int:
	randomize()

	return randi() % 256

## Returns a PoolByteArray filled with n random bytes
static func byte_array(size: int = 1) -> PoolByteArray:
	randomize()
	var array = []

	for i in range(0, size):
		array.append(byte())

	return PoolByteArray(array)

## Returns one or multiple random elements from an array
static func from_array(array: Array, num: int = 1, unique: bool = false) -> Array:
	assert(num >= 1, "RandUtils ERROR: Invalid element count.")

	if unique:
		assert(num <= len(array), "RandUtils ERROR: Ran out of characters.")

	randomize()

	if len(array) == 1:
		return array[0]
	elif num == 1:
		return [array[randi() % len(array)]]
	else:
		var results = []

		while num > 0:
			var index = randi() % len(array)
			results.append(array[index])
			num -= 1

			if unique:
				array.remove(index)

		return results

## RNGTOOLS


# Generates a random integer between `from` (inclusive) and `to` (exclusive).
# If `from` equals `to`, returns it.
static func randi_range(from: int, to: int, rng=null) -> int:
	if from == to:
		return from
	elif from > to:
		var swp := from + 1
		from = to + 1
		to = swp

	return (_randi(rng) % (to - from)) + from


# Shuffles an array in-place.
static func shuffle(array: Array, rng=null):
	var size := array.size()
	for i in range(size - 1):
		var swap = randi_range(i, size, rng)
		var tmp = array[i]
		array[i] = array[swap]
		array[swap] = tmp


# Returns one element of the array at random, or null if the array is empty.
static func pick(array: Array, rng=null):
	if array.empty():
		return null
	else:
		return array[randi_range(0, array.size(), rng)]


# Picks n elements of the array at random, or the entire array if its length
# is less than or equal to n. The resulting array will be in the same order as
# in the input array.
static func pick_many(array: Array, n: int, rng=null) -> Array:
	var result := []
	var size := array.size()
	var needed := float(n)
	for i in range(size):
		if _randf(rng) < needed / (size - i):
			result.append(array[i])
			needed -= 1
	return result


# Picks one element of the bag at random, according to the weights specified
# in the WeightedBag.
static func pick_weighted(bag: WeightedBag, rng=null):
	if bag.weights.empty():
		return null

	var n := bag._keys.size()
	var x := _randf(rng)
	var i := floor(n * x) as int
	var y := ((n * x) - i) * bag._sum

	if y >= bag._u[i]:
		i = bag._k[i]

	return bag._keys[i]


# A "bag" of weighted values. Used in conjunction with pick_weighted().
class WeightedBag:
	# See https://en.wikipedia.org/wiki/Alias_method

	# A map of keys to their weights.
	var weights := {} setget set_weights

	# Sum of weights
	var _sum := 0
	# Probability table
	var _u: PoolIntArray
	# Alias table
	var _k: PoolIntArray
	# Original probabilities
	var _p: PoolIntArray
	# Map of indices to the original keys we were given
	var _keys := []


	# Sets the weights for this bag. The keys of the dictionary may be any
	# values; they are what is returned by pick_weighted(). The dictionary
	# values are the weights, as integers.
	func set_weights(new_weights: Dictionary) -> void:
		weights = new_weights

		var n := weights.size()

		_sum = 0

		_u = PoolIntArray()
		_u.resize(n)
		_k = PoolIntArray()
		_k.resize(n)
		_p = PoolIntArray()
		_p.resize(n)

		_keys = weights.keys()
		for i in range(n):
			var w: int = weights[_keys[i]]
			_sum += w
			_p[i] = w

		var overfull := []
		var underfull := []

		# Initialize the probability table
		for i in range(n):
			var u: int = n * _p[i]
			_u[i] = u
			if u > _sum:
				overfull.push_back(i)
			elif u < _sum:
				underfull.push_back(i)

		# Distribute aliases
		while not overfull.empty():
			var i: int = overfull.pop_back()
			var j: int = underfull.pop_back()

			_k[j] = i
			_u[i] = _u[i] + _u[j] - _sum

			if _u[i] > _sum:
				overfull.push_back(i)
			elif _u[i] < _sum:
				underfull.push_back(i)


# Drop-in replacement for randi() that uses a RandomNumberGenerator if given,
# otherwise uses randi().
static func _randi(rng) -> int:
	if rng == null:
		return randi()
	else:
		var i = rng.randi()
		return rng.randi()

# Same as _randi(), but for randf()
static func _randf(rng) -> float:
	if rng == null:
		return randf()
	else:
		return rng.randf()

