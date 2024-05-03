local M = {}

local test_utils = require("test.utils")
local test_suite_git_operations = 'git_operations';
local T = test_utils.init_test_suite(test_suite_git_operations);

local utils = require('utils').U;

local function get_repo_from_origin(url)
    local i = url:find('/')
    return url:sub(i + 1, url:len() - ('.git'):len());
end

test_utils.test(function()
    local url = 'git@github.com:erandjo/pr.nvim.git';
    local repo = get_repo_from_origin(url);
    assert(repo == 'pr.nvim');
end, T, "test_get_repo_from_origin_url")

local function get_owner_from_origin(url)
    local _, i = url:find('git@github.com:');
    local j = url:find('/')
    return url:sub(i + 1, j - 1);
end

test_utils.test(function()
    local url = 'git@github.com:erandjo/pr.nvim.git';
    local owner = get_owner_from_origin(url);
    assert(owner == 'erandjo');
end, T, "test_get_owner_from_origin_url")

local function parse_origin_url_from(config)
    return config:sub(config:find('git@github.com:'), config:len());
end

test_utils.test(function()
    local config = "file:.git/config        remote.origin.url=git@github.com:erandjo/pr.nvim.git";
    local url = parse_origin_url_from(config);
    assert(url == "git@github.com:erandjo/pr.nvim.git")
end, T, "test_parse_origin_url_from_config")

--- Integration function. Does not require a test.
local function read_file(handle, mode)
    if (handle == nil) then
        print('File handle was nil');
        handle:close();
        return handle
    end
    local content = handle:read(mode);
    handle:close();
    return content;
end

--- Integration function. Does not require test.
local function git_remote_origin()
    local cmd = "git config --list --local --show-origin | grep \"remote.origin.url\"";
    return parse_origin_url_from(read_file(io.popen(cmd), '*l'));
end

local function cmd_fetch_prs(owner, repo)
    local headers = [[\
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    ]];
    local id = "/repos/" .. owner .. "/" .. repo .. "/pulls";
    return utils.trim("gh api " .. headers .. id);
end

test_utils.test(function()
    local expected_pr_request = utils.trim([[gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/erandjo/pr.nvim/pulls
    ]]);
    local request = cmd_fetch_prs("erandjo", "pr.nvim")
    assert(expected_pr_request == request)
end, T, "test_cmd_fetch_prs")


--- Integration function
local function gh_list_prs()
    local cmd = cmd_fetch_prs(
        get_owner_from_origin(git_remote_origin()),
        get_repo_from_origin(git_remote_origin()))
    print(read_file(io.popen(cmd), '*a'))
end

return { M = M, T = T };

-- should place some safety rails on integration functions so that it is easy
-- to spot if anything external has changed.
