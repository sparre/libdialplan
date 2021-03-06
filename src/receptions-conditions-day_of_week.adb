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

with Ada.Characters.Handling,
     Ada.Characters.Latin_1,
     Ada.Strings.Fixed,
     Ada.Strings.Unbounded;

with Receptions.Messages.Critical;

package body Receptions.Conditions.Day_Of_Week is
   not overriding
   function Create (List : in String) return Instance is
      use Ada.Calendar.Formatting,
          Ada.Strings.Fixed;

      From  : Positive := List'First;
      Comma : Natural;
   begin
      return Result : Instance do
         loop
            Comma := Index (Source  => List (From .. List'Last),
                            Pattern => ",");

            exit when Comma = 0;

            Result.Days (Day_Name'Value (List (From .. Comma - 1))) := True;

            From := Comma + 1;
         end loop;

         Result.Days (Day_Name'Value (List (From .. List'Last))) := True;
      end return;
   exception
      when E : others =>
         Messages.Critical.Exception_Raised
           (Information => E,
            Source      => "Receptions.Conditions.Day_Of_Week.Create");
         raise;
   end Create;

   overriding
   function FreeSWITCH_XML (Item : in Instance) return String is
      use Ada.Calendar.Formatting,
          Ada.Characters.Handling,
          Ada.Characters.Latin_1,
          Ada.Strings.Fixed,
          Ada.Strings.Unbounded;
      Result : Unbounded_String;
      Prefix : Unbounded_String := To_Unbounded_String (" <condition wday=""");
   begin
      for Day in Item.Days'Range loop
         if Item.Days (Day) then
            Append (Result, Prefix);
            Append (Result, To_Lower (Head (Day_Name'Image (Day), 3)));
            Prefix := To_Unbounded_String (",");
         end if;
      end loop;

      if Length (Result) = 0 then
         return " <false/>" & LF;
      else
         return To_String (Result) & """/>" & LF;
      end if;
   end FreeSWITCH_XML;

   overriding
   function True (Item : in Instance;
                  Call : in PBX_Interface.Call'Class) return Boolean is
      pragma Unreferenced (Call);
   begin
      return
        Item.Days (Ada.Calendar.Formatting.Day_Of_Week (Ada.Calendar.Clock));
   end True;

   overriding
   function Value (Item : in Instance) return String is
      use Ada.Calendar.Formatting,
          Ada.Strings.Unbounded;
      Result : Unbounded_String;
      Prefix : Unbounded_String := To_Unbounded_String ("Day of week in {");
   begin
      for Day in Item.Days'Range loop
         if Item.Days (Day) then
            Append (Result, Prefix);
            Append (Result, Day_Name'Image (Day));
            Prefix := To_Unbounded_String (",");
         end if;
      end loop;

      if Length (Result) = 0 then
         return "False";
      else
         return To_String (Result) & "}";
      end if;
   end Value;
end Receptions.Conditions.Day_Of_Week;
