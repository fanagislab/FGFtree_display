## draw tree and align figure for GDAP
## Author: Fanwei, fanw@genomics.org.cn 
## Creat on: 2006-3-28
package Tree::nhx_align_func_svg;
use strict;
use Tree::nhx_svg;
use vars qw(@ISA);
@ISA = qw(Tree::nhx_svg);


## creat a new obejct, and set the parameters
# Afer creat a new object, you must add block character 
# to the tree first, use the following method:
# $object->add_character("block",\%hit);
# you can use name_area, kaks_area, block_area to get
# map information on png figure.
sub new
{	
	my $invocant = shift;
	my $class = ref($invocant) || $invocant;
	my $self = Tree::nhx_svg->new(
		_node=>undef,				_root=>undef,
		_n_leaf=>undef,				_error=>undef,
							
		tree_dist=>0,				tree_width=>0,			
		width=>1000,					height=>0, 
		left_margin=>30,			right_margin=>510,
		top_margin=>5,				bottom_margin=>30,
		skip=>35,					is_real=>1,
		half_box=>3,				c_node=>"#0000FF",
		line_width=>1,				c_line=>"#0000FF",
		font=>'ArialNarrow',			fsize=>12,
		c_bg=>"#FFFFFF",			c_frame=>"#000000", 
		c_inter=>"#FF6600",			c_exter=>"#000000",
		c_status=>"#FF0000",		c_W=>"#FF00CC",
		c_B=>"darkgreen",			show_B=>1,
		show_inter=>0,				show_exter=>1,
		show_ruler=>1,				show_W=>1,
		show_frame=>1,				_svg=>'',
		exter_include=>1,			view_cut=>0,
		
		align_dist=>0,				align_width=>0,
		exon_size=>5,				intron_size=>1,
		align_left_margin=>510,		align_right_margin=>30,
		#c_gene=>"#999933",			c_rgene=>"#FF9900",

		c_intron=>"#000000",		c_status=>"#FF6600",
		c_frameshift=>"#000000",	show_frameshift=>1,
		c_stopcodon=>"#000000",		show_stopcodon=>1,
		down_shift=>15,				
		show_legend=>0,				legend_height=>80,
		show_header=>1,				header_height=>30,
		header_content=>'',
		@_ );
	
	bless($self, $class);
	return $self;
}


## draw legend
sub draw_align_legend{
	my $self = shift;
	my $svg = $self->{_svg};
	my $legend_y = $self->{height} - $self->{bottom_margin} - $self->{legend_height} + 30;
	my $horizontal_shift = 105;
	my $vertical_shift = 20;

	my ($x,$y) = ($self->{align_left_margin},$legend_y);
	$svg->text('x',$x+15,'y',$y+$self->{exon_size},'-cdata','identity','font-size',$self->{fsize}, 'font-family',$self->{font});
	
	$svg->text('x',$x,'y',$y+$self->{exon_size}  + 12,'-cdata','0','font-size',10, 'font-family',$self->{font});
	$svg->text('x',$x+25,'y',$y+$self->{exon_size} + 12,'-cdata','0.5','font-size',10, 'font-family',$self->{font});
	$svg->text('x',$x+55,'y',$y+$self->{exon_size} + 12,'-cdata','1','font-size',10, 'font-family',$self->{font});
	$y += $vertical_shift;
	my $gradient = $svg->gradient(
        -type => "linear",
        id    => "gradient_1",
		gradientUnits => "userSpaceOnUse",
		x1	=>	$x,
		x2	=>	$x+60,
		
    );
	$gradient->stop('offset'=>0,style=>"stop-color:#FFFF00");
	$gradient->stop('offset'=>0.5,style=>"stop-color:#FF0000");
	$gradient->stop('offset'=>1,style=>"stop-color:#000000");
	$svg->rect('x',$x, 'y',$y,'width',60,'height',$self->{exon_size} * 1.2,'fill','url(#gradient_1)');
	$svg->text('x',$x+70,'y',$y+$self->{exon_size},'-cdata','Exon','font-size',$self->{fsize}, 'font-family',$self->{font});
	
	
	$x += $horizontal_shift;
	$y -= $vertical_shift;
	$svg->rect('x',$x, 'y',$y,'width',20,'height',$self->{exon_size},"stroke","black",'fill',"none");
	$svg->text('x',$x+28,'y',$y+$self->{half_box}*2,'-cdata','Unaligned region','font-size',$self->{fsize}, 'font-family',$self->{font});

	
	$y += $vertical_shift;
	$svg->line('x1',$x,'y1',$y+5,'x2',$x+20,'y2',$y+5,'stroke',"black",'stroke-width',$self->{line_width});
	$svg->text('x',$x+28,'y',$y+$self->{half_box}*2,'-cdata','Intron','font-size',$self->{fsize}, 'font-family',$self->{font});

	$x += $horizontal_shift+10;
	$y -= $vertical_shift;
	$svg->text('x',$x+15,'y',$y+$self->{half_box}*2,'-cdata','Premature stop codon','font-size',$self->{fsize}, 'font-family',$self->{font});
	$y += 2;
	$x += 4;
	my $r = 4 ;
	$svg->circle('cx',$x,'cy',$y,'r',$r,'fill','white','stroke',$self->{c_stopcodon},'stroke-width',1);
	$svg->line('x1',$x-sqrt(0.5)*$r,'y1',$y-sqrt(0.5)*$r,'x2',$x+sqrt(0.5)*$r,"y2",$y+sqrt(0.5)*$r,'stroke',"#FF0000",'stroke-width',1);
	$svg->line('x1',$x-sqrt(0.5)*$r,'y1',$y+sqrt(0.5)*$r,'x2',$x+sqrt(0.5)*$r,"y2",$y-sqrt(0.5)*$r,'stroke',"#FF0000",'stroke-width',1);
	
	$y += $vertical_shift;
	$y -= 2;
	$x -= 4;
	$svg->text('x',$x+15,'y',$y+$self->{half_box}*2,'-cdata','Internal frame shift','font-size',$self->{fsize}, 'font-family',$self->{font});
	$y += 2;
	$x += 4;
	$svg->circle('cx',$x,'cy',$y,'r',$r,'fill','white','stroke',$self->{c_frameshift},'stroke-width',1);
	$svg->text('x',$x-3,'y',$y+$r-1,'fill',"#FF0000",'stroke-width',0,'-cdata','!','font-family','Courier',"font-size",10,"font-weight",'bold');
}

## draw exon-intron structure
sub draw_gene{
	my ($self, $xarray,$y,$strand,$color,$identity,$alignrate,$struct_info) = @_ ;
	my $exon_size = $self->{exon_size} ;
	$y -= $self->{exon_size}/2 - $self->{down_shift} ;
	#my $color = ($strand eq "+") ? $self->{c_gene} : $self->{c_rgene};
	my $pp = $xarray;
	my $svg = $self->{_svg};
	
	## draw intron lines
	for (my $i=0; $i<@$pp-2; $i+=2) {
		my ($x_start,$x_end) = ($pp->[$i+1],$pp->[$i+2]);
		$svg->line('x1',$x_start,'y1',$y+$exon_size/2,'x2',$x_end,'y2',$y+$exon_size/2,'stroke',$self->{c_intron},'stroke-width',$self->{intron_size});		
	}
	
	## draw exon rectanges
	for (my $i=0; $i<@$pp; $i+=2) {
		my ($x_start,$x_end) = ($pp->[$i],$pp->[$i+1]);
		
		$svg->rect('x',$x_start, 'y',$y,'width',($x_end-$x_start || 1),'height',$exon_size,'fill',$color,'stroke',$color,'stroke-width',1,'onclick',"alert('$struct_info')");
	}
	
#	## draw exon polygons to present strand
#	if ($strand eq "+") {
#		my $x_end = $pp->[@$pp-1];
#		my $x_start = $x_end - $exon_size ;
#		#$svg->rect('x',$x_start, 'y',$y,'width',$x_end-$x_start,'height',$exon_size,'fill',$self->{c_bg});
#		#$svg->polygon('points',[$x_start, $y,$x_start, $y+$exon_size,$x_end,$y+$exon_size/2],'fill',$color);
#
#
#	}elsif ($strand eq "-") {
#		my $x_start = $pp->[0];
#		my $x_end = $pp->[0] + $exon_size ;
#		#$svg->rect('x',$x_start, 'y',$y,'width',$x_end-$x_start,'height',$exon_size,'fill',$self->{c_bg}); 
#		#$svg->polygon('points',[$x_start,$y+$exon_size/2,$x_end,$y+$exon_size,$x_end,$y],'fill',$color);
#	}

}



## draw frameshift mark
sub draw_frameshift{
	my ($self,$x,$y) = @_ ;
	my $svg = $self->{_svg};
	my $r = 4;
	$y += $self->{down_shift};
	
	$svg->circle('cx',$x,'cy',$y,'r',$r,'fill','white','stroke',$self->{c_frameshift},'stroke-width',1);
	$svg->text('x',$x-3,'y',$y+$r-1,'fill',"#FF0000",'stroke-width',0,'-cdata','!','font-family','Courier',"font-size",10,"font-weight",'bold');
	#$svg->line('x1',$x,'y1',$y-$r,'x2',$x,"y2",$y+$r,'stroke',"#FF0000",'stroke-width',1);
}

## draw frameshift mark
sub draw_stopcodon{
	my ($self,$x,$y) = @_ ;
	my $svg = $self->{_svg};
	my $r = 4;
	$y += $self->{down_shift};
	
	#$svg->line('x1',$x,'y1',$y-5,'x2',$x,"y2",$y+5,'stroke',$self->{c_stopcodon},'stroke-width',2);
	$svg->circle('cx',$x,'cy',$y,'r',$r,'fill','white','stroke',$self->{c_stopcodon},'stroke-width',1);
	$svg->line('x1',$x-sqrt(0.5)*$r,'y1',$y-sqrt(0.5)*$r,'x2',$x+sqrt(0.5)*$r,"y2",$y+sqrt(0.5)*$r,'stroke',"#FF0000",'stroke-width',1);
	$svg->line('x1',$x-sqrt(0.5)*$r,'y1',$y+sqrt(0.5)*$r,'x2',$x+sqrt(0.5)*$r,"y2",$y-sqrt(0.5)*$r,'stroke',"#FF0000",'stroke-width',1);
}

## caculate logical X coordinate of exon and introns for block result
sub cacul_block_X{
	my $self = shift;
	my $array = $self->{_node};
	
#	Note: this function do not used, the alignrate feature is got from input.
#	##caculate alignrate
#	foreach my $p (@$array) {
#		if (!$p->{C} && defined $p->{block}) {
#			my ($align_len,$unalign_len,$align_rate);
#			my @ary = @{$p->{block}};
#			for (my $i=0; $i<@ary; $i+=2) {
#				$align_len += abs($ary[$i] - $ary[$i+1]) + 1;
#			}
#			$unalign_len = $p->{twoends}[0] + $p->{twoends}[1];
#			$align_rate = sprintf("%.2f",$align_len/($align_len+$unalign_len));
#			$p->{alignrate} = $align_rate;
#		}
#	}
	
	## find the max value in X-axis
	my $max;
	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{block}) {
			$p->{strand} = shift @{$p->{block}};
			$p->{startsite} = 1;
			$p->{endsite} = $p->{block}[-1] ;
			$p->{endsite} += $p->{twoends}[0] + $p->{twoends}[1] if(exists $p->{twoends});
			my $inmax = $p->{block}[-1];
			$inmax += $p->{twoends}[0] + $p->{twoends}[1] if(exists $p->{twoends});
			$max = $inmax if($inmax > $max);
		}
	}

	## caculate logical distance, take the max as 1.
	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{block}) {
			my $pp = $p->{block};
			
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] += $p->{twoends}[0] if(exists $p->{twoends});
			}

			if ($p->{strand} eq '-') {
				for (my $i=0; $i<@$pp; $i++) {
					$pp->[$i] = $p->{endsite} - $pp->[$i];
				}
				@$pp = reverse @$pp;
			}
			
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] /= $max;
			}

		}
	}

	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{frameshift}) {
			my $pp = $p->{frameshift};
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] += $p->{twoends}[0] if(exists $p->{twoends});
			}
			if ($p->{strand} eq '-') {
				for (my $i=0; $i<@$pp; $i++) {
					$pp->[$i] = $p->{endsite} - $pp->[$i];
				}
				@$pp = reverse @$pp;
			}
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] /= $max;
			}
		}
	}

	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{stopcodon}) {
			my $pp = $p->{stopcodon};
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] += $p->{twoends}[0] if(exists $p->{twoends});
			}
			if ($p->{strand} eq '-') {
				for (my $i=0; $i<@$pp; $i++) {
					$pp->[$i] = $p->{endsite} - $pp->[$i];
				}
				@$pp = reverse @$pp;
			}
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] /= $max;
			}
		}
	}
	
	return unless($max);

	
	foreach my $p (@$array) {
		if (!$p->{C}){
			$p->{startsite} /= $max;
			$p->{endsite}  /= $max;
		}
	}
	
	$self->{align_dist} = $max ;

}

## caculate real x coordinate of exon and introns for block result
sub cacul_block_x{
	my $self = shift;
	$self->cacul_block_X;
	my $array = $self->{_node};
	
	my $real_x= $self->{width}  - $self->{align_left_margin} - $self->{align_right_margin};
	my $shift_x = $self->{align_left_margin};
	
	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{block}) {
			my $pp = $p->{block};
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] = int($pp->[$i] * $real_x + $shift_x + 0.5);
			}
		}
	}

	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{frameshift}) {
			my $pp = $p->{frameshift};
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] = int($pp->[$i] * $real_x + $shift_x + 0.5);
			}
		}
	}
	
	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{stopcodon}) {
			my $pp = $p->{stopcodon};
			for (my $i=0; $i<@$pp; $i++) {
				$pp->[$i] = int($pp->[$i] * $real_x + $shift_x + 0.5);
			}
		}
	}

	foreach my $p (@$array) {
		if (!$p->{C}) {
			$p->{startsite} = int($p->{startsite} * $real_x + $shift_x + 0.5);
			$p->{endsite} = int($p->{endsite} * $real_x + $shift_x + 0.5);
		}
	}

	$self->{align_width} = $real_x ;
}


#sub kaks_map{
#	my $self = shift;
#
#}
#
#sub block_map{
#	my $self = shift;
#
#}

## plot block in the right part of the figure
sub plot_block{
	my $self = shift;
	$self->cacul_block_x;
	my $array = $self->{_node};
	my $svg = $self->{_svg};
	
	my @color; # 103 colors
	for (my $green = 255; $green > 0; $green -= 5) {
		push @color,"rgb(255,$green,0)";	
	}
	for (my $red = 255; $red >= 0; $red -= 5) {
		push @color,"rgb($red,0,0)";
	}
	
	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{block}) {
			
			## my $col = ($p->{identity}) ? $color[ int ($p->{identity} * 102) ] : $color[0]; 
			my $col = "green";
			## draw aligned region
			$self->draw_gene($p->{block},$p->{y},$p->{strand},$col,sprintf("%.2f",$p->{identity}),sprintf("%.2f",$p->{alignrate}), $p->{structure_info} ); 
			##draw function description
			$svg->text('x',$self->{align_left_margin},'y',$p->{y}+3,'-cdata',$p->{function},"font-family",$self->{font},"font-size",$self->{fsize},"fill",'#000000');
			## draw unaligned region
			$svg->rect('x',$p->{startsite}, 'y',$p->{y} - $self->{exon_size}/2 + $self->{down_shift},'width',$p->{block}[0] - $p->{startsite},'height',$self->{exon_size},'fill',"none","stroke",$col) if($p->{block}[0] - $p->{startsite} >= 1);
			$svg->rect('x',$p->{block}[-1], 'y',$p->{y} - $self->{exon_size}/2 + $self->{down_shift},'width',$p->{endsite} - $p->{block}[-1],'height',$self->{exon_size},'fill',"none","stroke",$col)  if($p->{endsite} - $p->{block}[-1] >= 1);
			## caculate block map region
			my ($x_start,$x_end) = ($p->{block}[0],$p->{block}[-1]);
			$x_start = $p->{startsite} if($p->{block}[0] - $p->{startsite} >= 1);
			$x_end = $p->{endsite} if($p->{endsite} - $p->{block}[-1] >= 1); 
			$p->{block_area} = [ int($x_start), int($p->{y} - $self->{exon_size}/2 + $self->{down_shift}),
					int($x_end), int($p->{y} + $self->{exon_size}/2 + $self->{down_shift}) ];
		}
	}

	
	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{frameshift}) {
			foreach my $x (@{$p->{frameshift}}) {
				$self->draw_frameshift($x,$p->{y}) if($self->{show_frameshift} && $x > 0);
			}
			 
		}
	}
	
	foreach my $p (@$array) {
		if (!$p->{C} && defined $p->{stopcodon}) {
			foreach my $x (@{$p->{stopcodon}}) {
				$self->draw_stopcodon($x,$p->{y}) if($self->{show_stopcodon}  && $x > 0);
			}
			 
		}
	}

	## draw ruler
	my $ruler_y = $self->{height} - $self->{bottom_margin};
	$ruler_y -= $self->{legend_height} if($self->{show_legend});
	$self->plot_ruler($ruler_y, $self->{align_left_margin}, $self->{align_left_margin} + $self->{align_width}, $self->{align_dist}, "bp","right") if($self->{show_ruler} && $self->{align_dist} && $self->{align_width} );

}


sub plot{
	my $self = shift;
	$self->plot_core();
	$self->plot_block();
	$self->draw_align_legend() if($self->{show_legend});
	my $out = $self->{_svg}->xmlify();
#	$out =~ s/<!DOCTYPE.+?>//s;
#	$out =~ s/\s+xmlns=.+?>/>/s;
#	$out =~ s/<!--.+?-->//s;
	
	return $out;
}


1;

__END__



		
