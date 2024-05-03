local api_tests = require('infrastructure.list_prs').T;
local utils_test = require('utils').T;
local test_utils = require('test.utils');

test_utils.pretty_print_suite{ suite = api_tests, deep = true }
test_utils.pretty_print_suite{ suite = utils_test, deep = false }
