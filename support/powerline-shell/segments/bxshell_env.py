from powerline_shell.utils import BasicSegment
import os
import json

class Segment(BasicSegment):
  def add_to_powerline(self):
    self.powerline.append(" %s " % os.environ['BXSHELL_TARGET'],
      self.powerline.theme.IBMCLOUD_ENV_FG,
      self.powerline.theme.IBMCLOUD_ENV_BG)
