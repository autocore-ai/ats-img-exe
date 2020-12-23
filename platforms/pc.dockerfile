ARG IMG_SRC
ARG IMG_BLD

FROM ${IMG_SRC} as src
FROM ${IMG_BLD} as build

COPY --from=src /AutowareArchitectureProposal /AutowareArchitectureProposal

RUN if [ $ROS_DISTRO = foxy ]; \
        then /bin/bash -c \
        'cd /AutowareArchitectureProposal \
        && source /opt/ros/$ROS_DISTRO/setup.bash \
        && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
        --merge-install \
        --catkin-skip-building-tests \
        --packages-up-to \
        simple_planning_simulator'; \
    elif [ $ROS_DISTRO = eloquent ]; \
        then /bin/bash -c \
        'cd /AutowareArchitectureProposal \
        && source /opt/ros/$ROS_DISTRO/setup.bash \
        && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
        --merge-install \
        --catkin-skip-building-tests \
        --packages-up-to \
        lidar_apollo_instance_segmentation'; \
    fi

FROM alpine

ARG REPO
LABEL org.opencontainers.image.source ${REPO}

COPY --from=build /AutowareArchitectureProposal/install /AutowareArchitectureProposal/install
COPY --from=build /VER /AutowareArchitectureProposal/install/RTM_VER
COPY --from=build /SHA /AutowareArchitectureProposal/install/RTM_SHA
COPY --from=build /AutowareArchitectureProposal/src/SRC_SHA /AutowareArchitectureProposal/install/SRC_SHA
COPY --from=build /AutowareArchitectureProposal/src/SRC_VER /AutowareArchitectureProposal/install/SRC_VER
COPY --from=build /AutowareArchitectureProposal/src/SRC_VCS /AutowareArchitectureProposal/install/SRC_VCS