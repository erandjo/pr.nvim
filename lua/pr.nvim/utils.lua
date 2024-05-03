local test_utils = require("test.utils")
local test_suite_utils = 'utils';

local T = test_utils.init_test_suite(test_suite_utils);

local U = {}

function U.trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

test_utils.test(function()
    local text = U.trim('\t \n \rtest');
    assert(text == 'test');
end, T, "test_trim_white_space_start")

test_utils.test(function()
    local text = U.trim('test \r \t \n');
    assert(text == 'test');
end, T, "test_trim_white_space_end")

test_utils.test(function()
    local text = U.trim('test \r \t \n test');
    assert(text == 'test \r \t \n test');
end, T, "test_not_trim_white_space_between")

return { U = U, T = T };
