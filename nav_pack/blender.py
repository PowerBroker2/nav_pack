"""

"""
import arm.logicnode
import arm.logicnode.arm_nodes as arm_nodes

import navnode_definitions


def register():
    # Register a category for the package
    arm_nodes.add_category(
        navnode_definitions.CATEGORY_NAME,
        icon='DISK_DRIVE',
        description=''
    )

    # Then register all the nodes
    navnode_definitions.register_all()
