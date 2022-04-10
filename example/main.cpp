#include <FGFDMExec.h>

int main(int argc, char **argv)
{
  JSBSim::FGFDMExec FDMExec;
  FDMExec.LoadScript(SGPath(argv[1]));
  FDMExec.RunIC();
  bool result = true;
  while (result) result = FDMExec.Run();
}
