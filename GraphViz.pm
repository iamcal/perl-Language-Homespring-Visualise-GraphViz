package Language::Homespring::Visualise::GraphViz;

$VERSION = 0.02;

use warnings;
use strict;
use GraphViz;

sub new {
        my $class = shift;
        my $self = bless {}, $class;

        my $options = shift;
        $self->{interp}	= $options->{interp};

        return $self;
}

sub do {
	my ($self) = @_;
	
	$self->{graph}	= GraphViz->new(
			directed => 0, 
			layout => 'dot',
			rankdir => 1, 
			epsilon => 1,
		);

	$self->add_node($self->{interp}->{root_node}, 1);

	return $self->{graph};
}

sub add_node {
	my ($self, $node, $rank) = @_;

	for(@{$node->{child_nodes}}){
		my $label = $_->{node_name_safe};
		$label =~ s/\\/\\\\/g;

		my $fillcolor = $_->{spring}?'#C0C0FF':'white';

		$self->{graph}->add_node(
			$_->{uid}, 
			label => $label,
			rank => $rank,
			fillcolor => $fillcolor,
			style => 'filled',
		);

		$self->{graph}->add_edge(
			$node->{uid} => $_->{uid},
			arrowtail => 'normal',
		) if ($node->{uid} != $self->{interp}->{root_node}->{uid});

		$self->add_node($_, $rank+1);
	}
}

__END__

=head1 NAME

Language::Homespring::Visulaise::GraphViz - A visual op-tree viewer for "Homespring"

=head1 SYNOPSIS

  use Language::Homespring;
  use Language::Homespring::Visualise::GraphViz;

  my $code = "bear hatchery Hello,. World ..\n powers";

  my $hs = new Language::Homespring();
  $hs->parse($code);

  my $vis = new Language::Homespring::Visualise::GraphViz({'interp' => $hs});
  print $vis->do()->as_gif;

=head1 DESCRIPTION

This module implements a viewer for Homespring op-trees,
using the GraphViz program. You can now see the rivers that
your code produces :)

=head1 METHODS

=over 4

=item new({'interp' => $hs})

Creates a new Language::Homespring::Visualise::GraphViz object. The single
hash argument contains initialisation info. The only key currently
supported (and required!) is 'interp', which should point to the
Language::Homespring object you wish to visualise.

=item do()

Returns a GraphViz object, with all nodes and edges for the current state
of the op-tree. You can then call standard GraphViz methods on this object
such as as_gif() and as_png() to output an image.

=back

=head1 AUTHOR

Copyright (C) 2003 Cal Henderson <cal@iamcal.com>

=head1 SEE ALSO

L<perl>

L<Language::Homespring>

L<http://www.graphviz.org/>

=cut

