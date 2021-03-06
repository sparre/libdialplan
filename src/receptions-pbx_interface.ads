-------------------------------------------------------------------------------
--                                                                           --
--                      Copyright (C) 2013-, AdaHeads K/S                    --
--                                                                           --
--  This is free software;  you can redistribute it and/or modify it         --
--  under terms of the  GNU General Public License  as published by the      --
--  Free Software  Foundation;  either version 3,  or (at your  option) any  --
--  later version. This library is distributed in the hope that it will be   --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of  --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     --
--  You should have received a copy of the GNU General Public License and    --
--  a copy of the GCC Runtime Library Exception along with this program;     --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
--  <http://www.gnu.org/licenses/>.                                          --
--                                                                           --
-------------------------------------------------------------------------------

with Ada.Calendar;

package Receptions.PBX_Interface is
   type Instance is interface;

   type Log_Level is (Debug, Information, Notice, Warning,
                      Error, Critical,    Alert,  Emergency);
   procedure Log (PBX     : in     Instance;
                  Level   : in     Log_Level;
                  Message : in     String) is abstract;

   type Call is interface;
   function Caller (PBX  : in Instance;
                    ID   : in Call'Class) return String is abstract;
   function Callee (PBX  : in Instance;
                    ID   : in Call'Class) return String is abstract;

   function Clock (PBX : in Instance) return Ada.Calendar.Time is
     (Ada.Calendar.Clock);
   function Today_Is (PBX : in Instance;
                      Day : in String) return Boolean is abstract;
end Receptions.PBX_Interface;
