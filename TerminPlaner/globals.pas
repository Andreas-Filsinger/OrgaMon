unit globals;

interface

var
 MyProgramPath : string;

implementation

begin
 MyProgramPath := paramstr(0);
end.
