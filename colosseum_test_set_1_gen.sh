#!/usr/bin/env bash

COLOSSEUM_15_TASKS=(
    'close_box' 
    'close_laptop_lid' 
    'hockey' 
    'meat_on_grill' 
    'wipe_desk'
    'open_drawer' 
    'slide_block_to_target' 
    'reach_and_drag' 
    'put_money_in_safe' 
    'place_wine_at_rack_location' 
    'insert_onto_square_peg' 
    'stack_cups' 
    'straighten_rope' 
    'setup_chess' 
    'scoop_with_spatula'
)

episode_num=${2:-25}

if [ $# -eq 0 ]
then
    echo "Collecting demos from all tasks"

    # colosseum_15
    tasks=("${COLOSSEUM_15_TASKS[@]}")
    
else
    echo "Collecting demos from task $1"
    tasks=("$1")
fi

# idx from which to collect demos (use -1 for all idxs)
# idx=0 No variation factors are enabled
# idx=1 All Colosseum variation factors are enabled (default rlbench variations)
# idx=13 RLBench associated variations per task are enabled
# idx=15 Both RLBench and Colosseum variations are enabled
IDX_TO_COLLECT=1 

SAVE_PATH=/srl_mvt/rvt2-vlm/rvt/data/colosseum_test_set/all_mixed_test_25
NUMBER_OF_EPISODES=${episode_num}
IMAGE_SIZE=(128 128)
MAX_ATTEMPTS=20
SEED=42
USE_SAVE_STATES="True"

IMAGES_USE_RGB="True"
IMAGES_USE_DEPTH="True"
IMAGES_USE_MASK="False"
IMAGES_USE_POINTCLOUD="False"

CAMERAS_USE_LEFT_SHOULDER="True"
CAMERAS_USE_RIGHT_SHOULDER="True"
CAMERAS_USE_OVERHEAD="True"
CAMERAS_USE_WRIST="True"
CAMERAS_USE_FRONT="True"

for task in "${tasks[@]}"
do
    echo "Processing task: $task"
    python -m colosseum.tools.dataset_generator --config-name $task \
            env.seed=$SEED \
            data.save_path=$SAVE_PATH \
            +data.max_attempts=$MAX_ATTEMPTS \
            +data.idx_to_collect=$IDX_TO_COLLECT \
            +data.use_save_states=$USE_SAVE_STATES \
            data.image_size=[${IMAGE_SIZE[0]},${IMAGE_SIZE[1]}] \
            data.episodes_per_task=$NUMBER_OF_EPISODES \
            data.images.rgb=$IMAGES_USE_RGB \
            data.images.depth=$IMAGES_USE_DEPTH \
            data.images.mask=$IMAGES_USE_MASK \
            data.images.point_cloud=$IMAGES_USE_POINTCLOUD \
            data.cameras.left_shoulder=$CAMERAS_USE_LEFT_SHOULDER \
            data.cameras.right_shoulder=$CAMERAS_USE_RIGHT_SHOULDER \
            data.cameras.overhead=$CAMERAS_USE_OVERHEAD \
            data.cameras.wrist=$CAMERAS_USE_WRIST \
            data.cameras.front=$CAMERAS_USE_FRONT
done
