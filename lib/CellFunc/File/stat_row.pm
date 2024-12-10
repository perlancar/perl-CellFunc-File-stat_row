package CellFunc::File::stat_row;

use strict;
use warnings;
use Log::ger;

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

our @st_fields = (
    "dev",     # 0
    "ino",     # 1
    "mode",    # 2
    "nlink",   # 3
    "uid",     # 4
    "gid",     # 5
    "rdev",    # 6
    "size",    # 7
    "atime",   # 8
    "mtime",   # 9
    "ctime",   # 10
    "blksize", # 11
    "blocks",  # 12
);

our @st_field_formats = (
    "number", # 0 "dev",
    "number", # 1 "ino",
    "", # 2 "mode",
    "number", # 3 "nlink",
    "number", # 4 "uid",
    "number", # 5 "gid",
    "number", # 6 "rdev",
    "filesize", # 7 "size",
    "iso8601_datetime", # 8 "atime",
    "iso8601_datetime", # 9 "mtime",
    "iso8601_datetime", # 10 "ctime",
    "number", # 11 "blksize",
    "number", # 12 "blocks",
);

our $resmeta = {
    'table.fields' => \@st_fields,
    'table.field_formats' => \@st_field_formats,
};

$SPEC{func} = {
    v => 1.1,
    summary => 'Take input value as filename, generate a row from stat()',
    description => <<'MARKDOWN',

When file does not exist or cannot be `stat()`'d, will emit a warning and return
an undefined value instead of a row.

MARKDOWN
    args => {
        value => {
            schema => 'filename*',
            req => 1,
            pos => 0,
        },
    },
};
sub func {
    my %args = @_;

    my @st = stat($args{value});
    unless (@st) {
        log_warn "Can't stat(%s): %s", $args{value}, $!;
        return [200, "OK"];
    }
    [200, "OK", \@st, $resmeta];
}

1;
# ABSTRACT: Take input value as filename, generate a row from stat()
