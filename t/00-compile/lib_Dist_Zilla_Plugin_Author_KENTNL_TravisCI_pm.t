# This test was generated for <lib/Dist/Zilla/Plugin/Author/KENTNL/TravisCI.pm>
# using by Dist::Zilla::Plugin::Test::Compile::PerFile ( @Author::KENTNL/Test::Compile::PerFile ) version 0.003901
# with template 02-raw-require.t.tpl
my $file = "Dist\/Zilla\/Plugin\/Author\/KENTNL\/TravisCI\.pm";
my $err;
{
  local $@;
  eval { require $file; 1 } or $err = $@;
};

if( not defined $err ) {
  printf "1..1\nok 1 - require %s\n", $file;
  exit 0;
}
printf "1..1\nnot ok 1 - require %s\n", $file;
for my $line ( split /\n/, $err ) {
  printf STDERR "# %s\n", $line;
}
exit 1;
