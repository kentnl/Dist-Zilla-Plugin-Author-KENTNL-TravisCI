use 5.006;    # our
use strict;
use warnings;

package Dist::Zilla::Plugin::Author::KENTNL::TravisCI;

our $VERSION = '0.001000';

# ABSTRACT: A specific subclass of TravisCI that does horrible things

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moose qw( extends );
extends 'Dist::Zilla::Plugin::TravisCI';

sub modify_travis_yml {
  my ( $self, %yaml ) = @_;
  my $allow_failures = [
    { perl => "5.8" },
    { env  => "STERILIZE_ENV=0 RELEASE_TESTING=1 AUTHOR_TESTING=1" },
    { env  => "STERILIZE_ENV=0 DEVELOPER_DEPS=1" },
  ];
  my $include = [
    { perl => "5.21", env => "STERILIZE_ENV=0 COVERAGE_TESTING=1" },
    { perl => "5.21", env => "STERILIZE_ENV=1" },
    ( map { +{ perl => $_, env => "STERILIZE_ENV=0" } } "5.8", "5.10", "5.12", "5.14", "5.16", "5.20", "5.21", ),
    ( map { +{ perl => $_, env => "STERILIZE_ENV=1" } } "5.8", "5.10", "5.20", ),
    { perl => "5.21", env => "STERILIZE_ENV=0 DEVELOPER_DEPS=1" },
    { perl => "5.21", env => "STERILIZE_ENV=0 RELEASE_TESTING=1 AUTHOR_TESTING=1" },
  ];
  $yaml{matrix} = {
    allow_failures => $allow_failures,
    include        => $include,
  };
  $yaml{before_install} = [
    "perlbrew list",
    "time git clone --depth 10 https://github.com/kentfredric/travis-scripts.git maint-travis-ci",
    "time git -C ./maint-travis-ci reset --hard master",
    "time perl ./maint-travis-ci/branch_reset.pl",
    "time perl ./maint-travis-ci/sterilize_env.pl",
  ];
  $yaml{install} = [
   'time perl ./maint-travis-ci/install_deps_early.pl',
   'time perl ./maint-travis-ci/install_deps.pl',
  ];
  $yaml{before_script} = [
    'time perl ./maint-travis-ci/before_script.pl',
  ];
  $yaml{script} = [
    "time perl ./maint-travis-ci/script.pl",
  ];
  $yaml{after_failure} = [
    "perl ./maint-travis-ci/report_fail_ctx.pl",
  ];
  $yaml{branches} = {
    only => [
      "master",
      "build/master",
      "releases",
    ]
  };
  delete $yaml{perl};
  return %yaml;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::Author::KENTNL::TravisCI - A specific subclass of TravisCI that does horrible things

=head1 VERSION

version 0.001000

=head1 DESCRIPTION

B<NO USER SERVICABLE PARTS INSIDE>

B<CHOKING HAZARD>

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
