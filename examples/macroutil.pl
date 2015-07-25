#!/usr/bin/perl

# Copyright (c) Mark Summerfield 2000. All Rights Reserved.
# May be used/distributed under the LGPL. 

# Documented at the __END__.

use strict;
use warnings;

use vars qw( $VERSION ) ;
$VERSION = '2.10_02'; 

use Path::Tiny;
use Image::Size 'html_imgsize' ;


BEGIN {
    my $ORIGPATH = Path::Tiny->cwd;
    my $offset   = $ORIGPATH =~ tr!/!/! ;

    sub relpath { 
        my $path     = Path::Tiny->cwd;
        my $newlevel = $path =~ tr!/!/! ;

        $newlevel -= $offset ;

        "../" x $newlevel ;
    }

    sub abspath {
        # Returns the `absolute' path if we take the original path to be root.
        my $path = Path::Tiny->cwd;

        $path =~ s!^$ORIGPATH!! ;

        $path .= '/' unless substr( $path, -1, 1 ) eq '/' ;

        $path ;
    }
}


sub today { 
    # If called with a number will return the localtime of that number;
    # otherwise will return the localtime of now.
    my $time = shift || time ;

    my( $day, $mon, $year ) = (localtime( $time ))[ 3..5 ] ;
    $mon++ ; 
    $year += 1900 ; 
    $day = "0$day" if $day < 10 ; 
    $mon = "0$mon" if $mon < 10 ;

    wantarray ? ( $year, $mon, $day ) : $year ;
}


sub imageif {
    # Returns '<IMG SRC...>' or '' depending on the date supplied.
    # See html.macro for examples of use.
    my $image = shift ;
    my $date  = shift ;
    my $alt   = shift || '' ;

    return '' unless $date ;
    my( $nyear, $nmon, $nday ) = $date =~ /^(\d\d\d\d)\D(\d\d?)\D(\d\d?)$/ ;
    my $compare = sprintf "%04d%02d%02d", $nyear, $nmon, $nday ;
    my( $year, $mon, $day ) = today ;

    if( $compare gt "$year$mon$day" ) {
        $alt = qq{ alt="$alt"} if $alt ;
        my $size = lc html_imgsize( $image ) || '' ; # The || ignores errors gracefully
        $size =~ s/(\d+)/"$1"/go ; # Add quotes to sizes for XHTML.
        qq{<img src="$image" $size$alt />} ; # Close the tag for XHTML
    }
    else {
        '' ; # Don't want to return undef.
    }
}


sub image {
    my $image = shift ;
    my $alt   = shift || '' ;

    $alt = qq{ alt="$alt"} if $alt ;
    my $size = lc html_imgsize( $image ) || '' ; # The || ignores errors gracefully
    $size =~ s/(\d+)/"$1"/go ; # Add quotes to sizes for XHTML
    qq{<img src="$image" $size$alt />} ; # Close the tag for XHTML
}


sub copyright {
    my $owner = shift ;
    my $year1 = shift || 1999 ;

    my( $year, $mon, $day ) = today ;
    my $cyear = $year1 || $year ;
    $cyear = "$year1-$year" if $year > $year1 ;

    my $copyright = "Copyright \&copy; $cyear $owner." ;

<<__EOT__ ;
<hr />
$copyright All\&nbsp;Rights\&nbsp;Reserved. Updated\&nbsp;$year/$mon/$day.
<!-- Generated by Text::MacroScript -->
__EOT__
}


1 ;


__END__

=head1 NAME

macroutil.pl - utility functions for use with Text::MacroScript 

=head1 SYNOPSIS

    %REQUIRE[macroutil.pl]

Having required this file you can use any of its functions (described below).
You can also of course C<%REQUIRE> any of your own libraries.

Functions provided:

    abspath
    copyright
    image
    imageif
    relpath
    today

=head1 DESCRIPTION

=head2 abspath()

This function returns a path which begins with `/' treating the script's
working directory as root. 

=head2 copyright()

Usage:

    copyright( 'MyCompany Inc' )

See html.macro for examples.

=head2 image()

This function returns an <IMG SRC..> tag.

    image( image, alt )

=head2 imageif()

This function returns either <IMG SRC...> if the date given is in the future
or an empty string if the date given is in the past. See html.macro for
examples of use. Usage:

    imageif( image, date, alt )

image is the path of the image, e.g. "/images/new.gif"
date is a date that matches /^\d\d\d\d\D\d\d?\D\d\d?$/ i.e. year/month/day
alt is the alt text which is optional, e.g. 'New'

=head2 relpath()

This function returns the path relative to where the calling script's working
directory was in terms of "../"s. See the C<html.macro> file for examples. 

=head2 today()

This function returns an array of ( year, month, day ) in a list context and
the scalar year in a a scalar context. The year is always four digits, the
month and day always two digits (i.e. leading zero if < 10); the month is in
the range 01..12. The date returned is today unless you pass in an integer
time value in which case the date that that value represents is returned. See
the C<html.macro> file for examples.

=head1 AUTHOR

Mark Summerfield. I can be contacted as <summer@perlpress.com> -
please include the word 'macroscript' in the subject line.

=head1 COPYRIGHT

Copyright (c) Mark Summerfield 2000. All Rights Reserved.

This module may be used/distributed/modified under the LGPL. 

=cut
