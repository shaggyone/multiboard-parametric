eps = 0.01;

// Main dimensions
cell_size = 25;
height = 6.4;

hole_thick = 3.6; // 3.280;
hole_thick_height = 2.4;
hole_thin = 1.6;

hole_rg_spiral_d=0.776;

hole_sm_d = 6.069+0.025; // 7.5;

// Single tile outer dimensions
side_l = cell_size/(1+2*cos(45));
bound_circle_d = side_l/sin(22.5);

size_l_offset = (cell_size - side_l)*0.5;

// Single tile hole dimensions
hole_thick_size = cell_size - hole_thick;
hole_thick_side_l = (cell_size - hole_thick)/(1+2*cos(45));
hole_thick_bound_circle_d = hole_thick_side_l/sin(22.5);

hole_thin_size = cell_size - hole_thin;
hole_thin_side_l = hole_thin_size/(1+2*cos(45));
hole_thin_bound_circle_d = hole_thin_side_l/sin(22.5);

large_thread_d1 = 22.5; // hole_thin_size - 0.6;
large_thread_d2 = hole_thick_size;
large_thread_h1 = 0.5;
large_thread_h2 = 1.583;
large_thread_fn=32;
large_thread_pitch = 2.5;

small_thread_pitch = 3;
small_thread_d1 = 7.025;
small_thread_d2 = 6.069;
small_thread_h1 = 0.768;
small_thread_h2 = small_thread_pitch-0.5;
small_thread_fn=32;


module multiboard_core_base(x_cells, y_cells) {
    board_width  = cell_size * x_cells;
    board_height = cell_size * y_cells;

    b_points = [for(i=[0: x_cells-1])
        each [
            [i*cell_size + size_l_offset,             0],
            [i*cell_size + cell_size - size_l_offset, 0],
            [i*cell_size + cell_size,                 0 + size_l_offset],
        ]
    ];

    r_points = [for(j=[0: y_cells-1])
        each [
            [board_width,               j*cell_size + size_l_offset],
            [board_width,               j*cell_size + cell_size - size_l_offset],
            [board_width+size_l_offset, j*cell_size + cell_size],
        ]
    ];

    t_points =  [for(i=[x_cells-1:-1:0])
        each [
            [i*cell_size + cell_size,                 board_height + size_l_offset],
            [i*cell_size + cell_size - size_l_offset, board_height],
            [i*cell_size + size_l_offset,             board_height],
        ]
    ];

    l_points = [for(j=[y_cells-1:-1:0])
        each [
            [0 + size_l_offset, j*cell_size + cell_size],
            [0,                 j*cell_size + cell_size - size_l_offset],
            [0,                 j*cell_size + size_l_offset],
        ]
    ];

    linear_extrude(height) {
        polygon([
            each b_points,
            each r_points,
            each t_points,
            each l_points,
        ]);
    }
}

module multiboard_side_base(x_cells, y_cells) {
    board_width  = cell_size * x_cells;
    board_height = cell_size * y_cells;

    b_points = [for(i=[0: x_cells-1])
        each [
            [i*cell_size + size_l_offset,             0],
            [i*cell_size + cell_size - size_l_offset, 0],
            [i*cell_size + cell_size,                 0 + size_l_offset],
        ]
    ];

    r_points = [for(j=[0: y_cells-1])
        each [
            [board_width,               j*cell_size + size_l_offset],
            [board_width,               j*cell_size + cell_size - size_l_offset],
            [board_width+size_l_offset, j*cell_size + cell_size],
        ]
    ];

    t_points =  [for(i=[x_cells-1:-1:0])
        each [
            [i*cell_size + cell_size,                 board_height - size_l_offset],
            [i*cell_size + cell_size - size_l_offset, board_height],
            [i*cell_size + size_l_offset,             board_height],
        ]
    ];

    l_points = [for(j=[y_cells-1:-1:0])
        each [
            [0 + size_l_offset, j*cell_size + cell_size],
            [0,                 j*cell_size + cell_size - size_l_offset],
            [0,                 j*cell_size + size_l_offset],
        ]
    ];

    linear_extrude(height) {
        polygon([
            each b_points,
            each r_points,
            each t_points,
            each l_points,
        ]);
    }
}

module multiboard_corner_base(x_cells, y_cells) {
    board_width  = cell_size * x_cells;
    board_height = cell_size * y_cells;

    b_points = [for(i=[0: x_cells-1])
        each [
            [i*cell_size + size_l_offset,             0],
            [i*cell_size + cell_size - size_l_offset, 0],
            [i*cell_size + cell_size,                 0 + size_l_offset],
        ]
    ];

    r_points = [for(j=[0: y_cells-1])
        each [
            [board_width,               j*cell_size + size_l_offset],
            [board_width,               j*cell_size + cell_size - size_l_offset],
            [board_width-size_l_offset, j*cell_size + cell_size],
        ]
    ];

    t_points =  [for(i=[x_cells-1:-1:0])
        each [
            [i*cell_size + cell_size,                 board_height - size_l_offset],
            [i*cell_size + cell_size - size_l_offset, board_height],
            [i*cell_size + size_l_offset,             board_height],
        ]
    ];

    l_points = [for(j=[y_cells-1:-1:0])
        each [
            [0 + size_l_offset, j*cell_size + cell_size],
            [0,                 j*cell_size + cell_size - size_l_offset],
            [0,                 j*cell_size + size_l_offset],
        ]
    ];

    linear_extrude(height) {
        polygon([
            each b_points,
            each r_points,
            each t_points,
            each l_points,
        ]);
    }
}



module multiboard_core(x_cells, y_cells) {
  difference() {
    multiboard_core_base(x_cells, y_cells);

    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
        translate([cell_size/2+i*cell_size, cell_size/2+j*cell_size])
          multiboard_tile_hole();
      }
    }
    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
          translate([cell_size+i*cell_size, cell_size+j*cell_size])
            multiboard_tile_hole_small();
      }
    }
  }
}

module multiboard_side(x_cells, y_cells) {
  difference() {
    multiboard_side_base(x_cells, y_cells);

    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
        translate([cell_size/2+i*cell_size, cell_size/2+j*cell_size])
          multiboard_tile_hole();
      }
    }
    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-2]) {
          translate([cell_size+i*cell_size, cell_size+j*cell_size])
            multiboard_tile_hole_small();
      }
    }
  }
}

module multiboard_corner(x_cells, y_cells) {
  difference() {
    multiboard_corner_base(x_cells, y_cells);

    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
        translate([cell_size/2+i*cell_size, cell_size/2+j*cell_size])
          multiboard_tile_hole();
      }
    }
    for(i=[0: x_cells-2]) {
      for(j=[0: y_cells-2]) {
          translate([cell_size+i*cell_size, cell_size+j*cell_size])
            multiboard_tile_hole_small();
      }
    }
  }
}



module multiboard_tile_hole_base() {
    rotate(22.5, [0, 0, 1]) {
        translate([0, 0, (height - hole_thick_height)/2])
            cylinder(d=hole_thick_bound_circle_d, h=hole_thick_height, $fn=8);
        cylinder(d1=hole_thin_bound_circle_d, d2=hole_thick_bound_circle_d,
            h=(height - hole_thick_height)/2, $fn=8);
        translate([0, 0, height-(height - hole_thick_height)/2])
            cylinder(d1=hole_thick_bound_circle_d, d2=hole_thin_bound_circle_d,
                h=(height - hole_thick_height)/2, $fn=8);
    }
}


module multiboard_tile_hole() {
    multiboard_tile_hole_base();
    //color("#0000F0")
    translate([0, 0, -large_thread_h2/2])
    trapz_thread(large_thread_d1, large_thread_d2,
        large_thread_h1, large_thread_h2,
        thread_len=height+large_thread_h2, pitch=large_thread_pitch, $fn=large_thread_fn);
}

module multiboard_tile_hole_small() {
    cylinder(d=hole_sm_d, h=height,$fn=small_thread_fn);
    //color("#0000F0")
    translate([0, 0, -small_thread_h2/2])
    trapz_thread(small_thread_d1, small_thread_d2,
        small_thread_h1, small_thread_h2,
        thread_len=height+small_thread_h2, pitch=small_thread_pitch, $fn=small_thread_fn);
}

function spiral_segment_points(profile_points, angle_offset, z_offset) =
    [for (p=profile_points)
        [
            p[0] * cos(angle_offset),
            p[0] * sin(angle_offset),
            p[1] + z_offset,
        ]
    ];

function spiral_points(profile_points, spiral_len, spiral_loop_pitch) =

    [for (i=[0:round($fn*spiral_len/spiral_loop_pitch)])
        each spiral_segment_points(
            profile_points,
            i * 360.0/$fn,
            i * spiral_loop_pitch/$fn
        )
    ];

function limit_point_number(point, profile_points_count) =
    point >= profile_points_count ? point - profile_points_count : point;

function spiral_segment_paths(profile_points_count, segment_number) =
    [

        each [for(point=[0:profile_points_count-1])
            [
                segment_number*profile_points_count+limit_point_number(point+1, profile_points_count),
                segment_number*profile_points_count+limit_point_number(point+1, profile_points_count)+profile_points_count,
                segment_number*profile_points_count+limit_point_number(point, profile_points_count)+profile_points_count,
                segment_number*profile_points_count+limit_point_number(point, profile_points_count)
            ]

        ],
    ];

function spiral_paths(profile_points_count, spiral_len, spiral_loop_pitch) =
    [for (i=[0:round($fn*spiral_len/spiral_loop_pitch)-1])

        each spiral_segment_paths(profile_points_count, i)
    ];

module trapz_thread(d1, d2, h1, h2, thread_len, pitch) {
    thread_profile = [
        [d1/2, -h1/2],
        [d1/2, h1/2],
        [d2/2, h2/2],
        [d2/2, -h2/2],
    ];
    points=spiral_points(thread_profile, thread_len, pitch);
    faces=[
        [each [3:-1:0]],
        each spiral_paths(4, thread_len, pitch),
        [each [len(points)-4:len(points)-1]],
    ];

    polyhedron(
        points=points,
        faces=faces
    );
}

// multiboard_core(3, 2);

// translate([0, 75, 0])
//     multiboard_side(3, 2);

// translate([0, 150, 0])
//     multiboard_corner(3, 2);
