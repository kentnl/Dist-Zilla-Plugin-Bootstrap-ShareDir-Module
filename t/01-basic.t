use strict;
use warnings;

use Test::More;
use Test::DZil qw( simple_ini );
use Dist::Zilla::Util::Test::KENTNL 1.003001 qw(dztest);
require Dist::Zilla::Plugin::Bootstrap::lib;
require Dist::Zilla::Plugin::Bootstrap::ShareDir::Module;
require File::ShareDir;
require Path::Tiny;

my $t = dztest();
$t->add_file(
  'dist.ini' => simple_ini(
    { name => 'E' },
    [ 'Bootstrap::lib', ],    #
    [ 'Bootstrap::ShareDir::Module', { 'E' => 'share/E' } ],
    ['=E'],
  )
);
$t->add_file( 'share/E/example.txt', q[ ] );
$t->add_file( 'lib/E.pm',            <<'EOF');
use strict;
use warnings;
package E;

use File::ShareDir qw( module_file );
use Path::Tiny qw( path );

sub register_component {}

our $content = path( module_file( 'E', 'example.txt' ) )->slurp;

1;
EOF

$t->build_ok;

note explain $t->builder->log_messages;

done_testing;
