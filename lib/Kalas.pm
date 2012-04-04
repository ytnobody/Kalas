package Kalas;
use strict;
use warnings;
use parent qw( Class::Accessor::Fast );
use Coro;
use Coro::Semaphore;
use FurlX::Coro;
our $VERSION = '0.01';

__PACKAGE__->mk_accessors( qw( max_threads requests_par_thread semaphore agent_params ) );

sub new {
    my ( $class, %args ) = @_;
    $args{max_threads} ||= 4;
    $args{requests_par_thread} ||= 10;
    $args{agent_params} ||= {};
    $args{agent_params}->{agent} ||= join( '/', __PACKAGE__, $VERSION );
    $args{agent_params}->{timeout} ||= 10;
    my $self = $class->SUPER::new( \%args );
    $self->semaphore( Coro::Semaphore->new( $self->max_threads ) );
    $self->{coros} = [];
    return $self;
}

sub crawl {
    my ( $self, @urls ) = @_;
    for my $url ( @urls ) {
        push @{$self->{coros}}, async {
            my $guard = $self->semaphore->guard;
            my $agent = FurlX::Coro->new( %{$self->agent_params} );
            $agent->env_proxy;
            return $agent->get( $url );
        };
    }
}

sub coros {
    my $self = shift;
    return @{$self->{coros}};
}

1;
__END__

=head1 NAME

Kalas - Multi-Thread URL Fetcher

=head1 SYNOPSIS

  use Kalas;
  my $k = Kalas->new();
  $k->crawl( @url_list );
  my @res_list = map{ $_->join } $k->coros;

=head1 DESCRIPTION

Kalas is a Multi-Thread URL Fetcher.

=head1 AUTHOR

satoshi azuma E<lt>ytnobody at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
