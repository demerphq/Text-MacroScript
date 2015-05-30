#!/usr/bin/perl

# Copyright (c) 2015 Paulo Custodio. All Rights Reserved.
# May be used/distributed under the GPL.

use strict;
use warnings;
use Test::More;
use Data::Dump 'dump';

my $ms;
use_ok 'Text::MacroScript';
require_ok 't/mytests.pl';

sub void(&) { $_[0]->(); () }

# escapes and concat
$ms = new_ok('Text::MacroScript', [-embedded => 1]);
is $ms->expand(), "";
is $ms->expand("hello"), "hello";

is $ms->expand("hello \\\n world"), "hello \\\n world";
is $ms->expand("hello \\% world"), "hello \\% world";
is $ms->expand("hello \\# world"), "hello \\# world";
is $ms->expand("hello ## world"), "hello ## world";

is $ms->expand("hello <:\\\n:> world"), "hello   world";
is $ms->expand("hello <:\\% world"), "hello % world";
is $ms->expand("hello \\# :>world"), "hello # world";
is $ms->expand("<:hello ## :>world"), "helloworld";

# variable expansion
$ms = new_ok('Text::MacroScript', [-embedded => 1]);
is $ms->expand("abc<:%DEFINE_VARIABLE*HELLO*[1+]:>def"), "abcdef";
is $ms->expand("<:#*HELLO*:>"), "1+";
is $ms->expand("<:#*HELL:><:O*:>"), "#*HELLO*";

# multiple line value and counting of []
$ms = new_ok('Text::MacroScript', [-embedded => 1]);
is $ms->expand("a<:%DEFINE_VARIABLE X [:>b"), "ab";
is $ms->expand("c<:[hello:>d"), "cd";
is $ms->expand("e<:|:>f"), "ef";
is $ms->expand("g<:world]:>h"), "gh";
is $ms->expand("i<:]:>j<:#X:>k"), "ij[hello|world]k";

done_testing;
