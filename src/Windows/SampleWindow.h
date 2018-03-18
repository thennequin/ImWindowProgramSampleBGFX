#ifndef __WINDOWS_SAMPLE_WINDOW_H__
#define __WINDOWS_SAMPLE_WINDOW_H__

#include "ImwWindow.h"
#include "ShortKeyManager.h"

class SampleWindow : public ImWindow::ImwWindow
{
public:
	SampleWindow();
	virtual ~SampleWindow();

	virtual void			OnGui() override;

	void					OnShortkeyInc();
	void					OnShortkeyDec();
protected:
	int						m_iCount;

	const ShortKeyManager::ShortKey*	m_pShortkeys[4];
};

#endif __WINDOWS_SAMPLE_WINDOW_H__