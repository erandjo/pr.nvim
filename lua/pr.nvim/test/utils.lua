local T = {}

--- create a table to add tests to.
--- @param name string name of test suite
---@return table with tests attached to it
function T.init_test_suite(name)
    return {
        name = name,
        success = true,
        tests = {}
    }
end

local function update_suite_assertion(suite, success)
    suite.success = success;
end

local function test_assertion(suite, tname, success, msg)
    update_suite_assertion(suite, success)
    suite.tests[tname] = {
        success = success,
        msg = msg,
    }
end

--- Takes in a function that includes an assert and see wether it fails
--- @param fn function function under test
--- @param suite table suite name
--- @param tname string name
function T.test(fn, suite, tname)
    local success, err = pcall(fn);
    test_assertion(suite, tname, success, err)
end

--- Simple function for printing tests
--- @param args table that includes tests and deep
--- deep is intended as optional and determine when to show all test results
--- tests are the run tests
function T.pretty_print_suite(args)
    print("suite: " .. args.suite.name)
    print("success: " .. tostring(args.suite.success))
    if not args.deep and args.suite.success then
        goto continue
    end
    for tname, data in pairs(args.suite.tests) do
        print("name: " .. tname)
        for k, v in pairs(data) do
            print(" " .. k .. ": ", v)
        end
    end
    ::continue::
end

return T;
