#ifndef __WINDOWS_SAMPLE_WINDOW_H__
#define __WINDOWS_SAMPLE_WINDOW_H__

#include "ImwWindow.h"

class SampleWindow : public ImWindow::ImwWindow
{
public:
	SampleWindow();

	virtual void			OnGui() override;
};

#endif __WINDOWS_SAMPLE_WINDOW_H__