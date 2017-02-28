#!perl
use strict;
use warnings;
return sub {
  push @{ $_[0]->{install} }, 'time cpanm --quiet --notest --no-man-pages --dev Dist::Zilla::Plugin::Test::Compile::PerFile';
};
