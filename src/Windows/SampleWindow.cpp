
#include "SampleWindow.h"

#include "Program.h"

#include "ShortKeyManager.h"

SampleWindow::SampleWindow()
{
	m_iCount = 0;

	SetTitle("Sample");
	SetClosable(false);

	m_pShortkeys[0] = ShortKeyManager::GetInstance()->RegisterShortKey("Test Increment", "LeftCtrl+K", new EasyWindow::InstanceCaller<SampleWindow, void>(this, &SampleWindow::OnShortkeyInc), false);
	m_pShortkeys[1] = ShortKeyManager::GetInstance()->RegisterShortKey("Test Decrement", "RightCtrl+K", new EasyWindow::InstanceCaller<SampleWindow, void>(this, &SampleWindow::OnShortkeyDec), false);

	m_pShortkeys[2] = ShortKeyManager::GetInstance()->RegisterShortKey("Test Increment bis", "Ctrl+J", new EasyWindow::InstanceCaller<SampleWindow, void>(this, &SampleWindow::OnShortkeyInc), false);
	m_pShortkeys[3] = ShortKeyManager::GetInstance()->RegisterShortKey("Test Decrement bis", "Ctrl+Shift+J", new EasyWindow::InstanceCaller<SampleWindow, void>(this, &SampleWindow::OnShortkeyDec), false);
}

SampleWindow::~SampleWindow()
{
	ImwVerify(ShortKeyManager::GetInstance()->UnregisterShortKey(m_pShortkeys[0]));
	ImwVerify(ShortKeyManager::GetInstance()->UnregisterShortKey(m_pShortkeys[1]));
	ImwVerify(ShortKeyManager::GetInstance()->UnregisterShortKey(m_pShortkeys[2]));
	ImwVerify(ShortKeyManager::GetInstance()->UnregisterShortKey(m_pShortkeys[3]));
}

void SampleWindow::OnGui()
{
	ImGui::Text("I'm a sample\nYou can't close me");
	if (ImGui::Button("Quit"))
	{
		Program::GetInstance()->AskExit();
	}

	ImGui::Text("Shortkey for increment value: %s", m_pShortkeys[0]->m_sShortKey.c_str());
	ImGui::Text("Shortkey for increment value (alternative): %s", m_pShortkeys[2]->m_sShortKey.c_str());
	ImGui::Text("Shortkey for decrement value: %s", m_pShortkeys[1]->m_sShortKey.c_str());
	ImGui::Text("Shortkey for decrement value (alternative): %s", m_pShortkeys[3]->m_sShortKey.c_str());
	ImGui::Text("Value : %d", m_iCount);

	static char s_pText[256] = { 0 };
	ImGui::InputText("Input text", s_pText, 256);

	if (ImGui::Button("Open shortkey window"))
	{
		new ShortKeyWindow();
	}
}

void SampleWindow::OnShortkeyInc()
{
	++m_iCount;
}

void SampleWindow::OnShortkeyDec()
{
	--m_iCount;
}