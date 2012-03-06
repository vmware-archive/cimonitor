#! /usr/bin/env bash

source /Users/nctx/.rvm/scripts/rvm
cd /Users/nctx/workspace/cimonitor
rvm use ruby-1.9.2-p290@cimonitor
RAILS_ENV=production bundle exec rake cimonitor:fetch_statuses > fetch_statuses.log 2>&1

