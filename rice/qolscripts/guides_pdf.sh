#!/bin/bash

zathura $HOME/.guides/pdf/$(ls .guides/pdf | dmenu )
