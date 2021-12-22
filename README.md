An intuitive lightweight unit testing module for Lua and MoonScript modules. Factos follows Lua's philosophy and doesn't interfere with your method of testing. No need for ugly methods like `assertTrue`, `assertFalse`, etc or the compulsory "test_" prefix. 

Factos relies solely on Lua's assert function and pcall function for testing and error handling respectively. Lua's error messages also provide insights into which lines of code have failed the assertion.

# Usage

No need for complex compilation, Factos is a pure Lua module. Just copy the `factos.lua` or `factos.moon` to the directory that contains the test files or `test` directory.

```
$ git clone https://github.com/thelaycon/factos.git
```

## Example 

Consider a module called `mymodule` that has a directory like below:

```
factos.lua
mymodule.moon
mymodule.lua
tests.moon
tests.lua

```

The module can be as simple as below or even complex:

```
-- MoonScript

add = (x,y) ->
	return x+y

sub = (x,y) ->
	return x-y

return {
	add:add,
	sub:sub
	}

```


```
-- Lua 


local add

add = function(x, y)
  return x + y
end

local sub
sub = function(x, y)
  return x - y
end

return {
  add = add,
  sub = sub
}


```


Factos searches for a folder or file named `tests` or `tests.lua`. The preferences on which to use for testing depends entirely on Lua. You can use a single file `tests.lua` for small projects. Notice that it is "tests\*" not "test\*".

The `tests.moon` file should look like below: 


```

mymodule = require "mymodule"
mytests = {}

mytests.test_add = () ->
	assert mymodule.add(1,1) == 2

mytests.test_sub = () ->
	assert mymodule.sub(2,1) == 1

return {
	mytests
	}


```


The `tests.lua` file should look like below:

```

local mymodule = require("mymodule")
local mytests = { }

mytests.test_add = function()
  return assert(mymodule.add(1, 1) == 2)
end

mytests.test_sub = function()
  return assert(mymodule.sub(2, 1) == 1)
end

return {
  mytests
}


```


What did we just do?

--> We imported the needed modules to be tested with the `require` function. We wanted to test a supposed `add(x,y)` function in `mymodule.lua`.

--> We declared an empty table and added the functions to the table. You can define the table in your own way.

--> We returned the tests table in a table. This is important because it allows Factos to perform tests on a test directory as you will soon see.


The way you name your tests is entirely up to you, you mustn't prefix it with `test_`.

Now, let's test!

```
$ lua54 factos.lua
```

We should get:

```

test_add passed



test_sub passed

=====================


Results:

Passed: 2 tests.
Failed: 0 tests.

Time taken: 0.06 seconds.

============== All tests passed successfully ==============	


```


In a situation where we have a directory structured as below:

```

factos.lua
mymodule/
 init.lua
 others.lua
tests/
 init.lua
 test_arith.lua


```

Our tests can now be contained under a single folder. However, we must declared an `init.lua` file that returns a table of each test file contained in the tests directory.

```
-- tests/init.lua


arith = require("tests.test_arith")

return {
	arith=arith,
}

```


Each test file must return just the tests table instead of a nested table as we previously did.

```
-- tests/test_arith.lua


local mymodule = require("..mymodule")  -- We go one step backwards
local mytests = { }

mytests.test_add = function()
  return assert(mymodule.add(1, 1) == 2)
end

mytests.test_sub = function()
  return assert(mymodule.sub(2, 1) == 1)
end

return mytests  -- Just a table. Not nested.


```


Run:


```
lua54 factos.lua
```

The results should be similar to the last one:

```

test_sub passed



test_add passed

=====================


Results:

Passed: 2 tests.
Failed: 0 tests.

Time taken: 0.12 seconds.

============== All tests passed successfully ==============


```


If there are any failed tests, Factos will specify that as well.
