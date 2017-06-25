
#include "SampleWindow.h"

#include "Program.h"

SampleWindow::SampleWindow()
{
	SetTitle("Sample");
	SetClosable(false);
}

void SampleWindow::OnGui()
{
	ImGui::Text("I'm a sample\nYou can't close me");
	if (ImGui::Button("Quit"))
	{
		Program::GetInstance()->AskExit();
	}
}