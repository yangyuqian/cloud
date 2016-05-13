#!/bin/bash

source init.sh

ps -ef|grep km|awk '{print $2}'|xargs kill -9
