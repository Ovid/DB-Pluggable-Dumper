package DB::Pluggable::Dumper;

use strict;
use warnings;
use 5.008;
use Data::Dumper ();

use parent 'DB::Pluggable::Plugin';

my $eval = \&DB::eval;

sub register {
    my ( $self, $context ) = @_;
    $self->make_command( xx => sub { }, );
}

{
    package    # hide from pause
      DB;
    *eval = sub {
        if ( $DB::evalarg =~ s/\n\s*xx\s+([^\n]+)$/\n $1/ ) {
            no warnings 'redefine';
            local $DB::onetimeDump = 'dump';    # main::dumpvar shows the output
            local *DB::dumpit = sub {
                my ( $fh, $res ) = @_;
                my $dd = Data::Dumper->new( [] );
                $dd->Terse(1)->Indent(1)->Useqq(1)->Deparse(1)->Quotekeys(0)
                  ->Sortkeys(1);
                print $fh $dd->Values($res)->Dump;
            };
            $eval->();
        }
        else {
            $eval->();
        }
    };
}

1;

=head1 NAME

DB::Pluggable::Dumper - Add 'xx' dumper to debugger

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 AUTHOR

Curtis "Ovid" Poe, C<< <ovid at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-db-pluggable-dumper at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DB-Pluggable-Dumper>.  I will
be notified, and then you'll automatically be notified of progress on your bug
as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DB::Pluggable::Dumper

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DB-Pluggable-Dumper>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DB-Pluggable-Dumper>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DB-Pluggable-Dumper>

=item * Search CPAN

L<http://search.cpan.org/dist/DB-Pluggable-Dumper/>

=back

=head1 ACKNOWLEDGEMENTS

=over 4

=item * Marcel Grünauer (for L<DB::Pluggable>)

=item * Matt Trout (for L<Data::Dumper::Concise>)

=item * Vienna.pm, for sponsoring the 2010 Perl QA Hackathon

=back

=head1 COPYRIGHT & LICENSE

Copyright 2010 Curtis "Ovid" Poe, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of DB::Pluggable::Dumper
