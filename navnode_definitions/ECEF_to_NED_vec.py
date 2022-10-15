import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class ECEF2NEDNode(ArmLogicTreeNode):
    bl_idname = 'LNECEF2NEDNode'
    bl_label  = 'ECEF to NED'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',  'Planet semi-major axis (m)')
        self.add_input('ArmFloatSocket',  'Planet first eccentricity')
        self.add_input('ArmVectorSocket', 'ECEF [m, m, m]')
        self.add_input('ArmVectorSocket', 'LLA Reference [dd, dd, m]')

        self.add_output('ArmVectorSocket', 'NED [m, m, m]', is_var=True)