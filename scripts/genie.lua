-- Just change solution/project name and project GUID

local PROJECT_DIR          = (path.getabsolute("..") .. "/")
local PROJECT_BUILD_DIR    = path.join(PROJECT_DIR, ".build/")
local PROJECT_PROJECTS_DIR = path.join(PROJECT_DIR, ".projects")
local PROJECT_RUNTIME_DIR  = path.join(PROJECT_DIR, "Output/")
local BGFX_ROOT_DIR        = path.join(PROJECT_DIR, "Externals/")


BGFX_DIR        = path.join(BGFX_ROOT_DIR, "bgfx")
BX_DIR          = path.join(BGFX_ROOT_DIR, "bx")
BIMG_DIR        = path.join(BGFX_ROOT_DIR, "bimg")

-- Required for bgfx and example-common
function copyLib()
end

function compat(_bxDir)
	-- VS
	configuration { "vs*" }
		includedirs { path.join(_bxDir, "include/compat/msvc") }

	configuration { "vs2008" }
		includedirs { path.join(_bxDir, "include/compat/msvc/pre1600") }

	-- MinGW
	configuration { "*mingw*" }
		includedirs { path.join(_bxDir, "include/compat/mingw") }

	-- OSX
	configuration { "osx* or xcode*" }
		includedirs { path.join(_bxDir, "include/compat/osx") }

	configuration {} -- reset configuration
end

solution "Program"
	language				"C++"
	configurations			{ "Debug", "Release" }
	platforms				{ "x32", "x64" }

	defines
	{
		"ENTRY_CONFIG_IMPLEMENT_DEFAULT_ALLOCATOR=1",
		"BX_CONFIG_ENABLE_MSVC_LEVEL4_WARNINGS=1",
		"BGFX_CONFIG_DEBUG=1",
	}

	configuration { "vs* or mingw-*" }
		defines
		{
			"BGFX_CONFIG_RENDERER_DIRECT3D11=1",
		}

	configuration {}

	dofile (path.join(BX_DIR, "scripts/toolchain.lua"))
	if not toolchain(PROJECT_PROJECTS_DIR, BGFX_ROOT_DIR) then
		return -- no action specified
	end
	
	location				(path.join(PROJECT_PROJECTS_DIR, _ACTION))
	objdir					(path.join(PROJECT_BUILD_DIR, _ACTION))

	dofile (path.join(BX_DIR, "scripts/bx.lua"))
	dofile (path.join(BIMG_DIR, "scripts/bimg.lua"))
	dofile (path.join(BGFX_DIR, "scripts/bgfx.lua"))

	bgfxProject("", "StaticLib", {})

	startproject "Program"
	project "Program"
		uuid				"e0ba3c4d-338b-4517-8bbd-b29311fd6830"
		kind				"WindowedApp"
		targetdir			(PROJECT_RUNTIME_DIR)

		files {
							"../src/**.cpp",
							"../src/**.h",

							"../Externals/imgui/imconfig.h",
							"../Externals/imgui/imgui.h",
							"../Externals/imgui/imgui_internal.h",
							"../Externals/imgui/imgui.cpp",
							"../Externals/imgui/imgui_draw.cpp",
							"../Externals/imgui/SFF_rect_pack.h",
							"../Externals/imgui/SFF_textedit.h",
							"../Externals/imgui/SFF_truetype.h",

							"../Externals/ImWindow/ImWindow/**.cpp",
							"../Externals/ImWindow/ImWindow/**.h",

							"../Externals/ImWindow/ImWindowBGFX/EasyWindow*.cpp",
							"../Externals/ImWindow/ImWindowBGFX/EasyWindow.h",
							"../Externals/ImWindow/ImWindowBGFX/Imw**.cpp",
							"../Externals/ImWindow/ImWindowBGFX/Imw**.h",
		}
		
		vpaths {
							["ImGui"] = "../Externals/imgui/**",
							["ImWindow"] = "../Externals/ImWindow/ImWindow/**",
							["ImWindowBGFX"] = "../Externals/ImWindow/ImWindowBGFX/**"
		}
		
		includedirs {
							"../Externals/imgui",
							"../Externals/ImWindow/ImWindow",
							"../Externals/ImWindow/ImWindowBGFX",
							"../src/",

							path.join(BX_DIR, "include"),
							path.join(BX_DIR, "3rdparty"),
							path.join(BGFX_DIR, "include"),
							path.join(BGFX_DIR, "3rdparty"),
							path.join(BGFX_DIR, "examples/common"),
							--path.join(BGFX_DIR, "3rdparty/forsyth-too"),
							path.join(BIMG_DIR, "include"),
							path.join(BIMG_DIR, "3rdparty"),
		}

		links {
							"bgfx",
							"bimg",
							"bx"
		}
	
		configuration		"Debug"
			targetsuffix	"_d"
			flags			{ "Symbols" }
			
		configuration		"Release"
			targetsuffix	"_r"
			flags			{ "Optimize" }

		configuration {}

		configuration { "vs*" }
		buildoptions
		{
			"/wd 4127", -- Disable 'Conditional expression is constant' for do {} while(0).
			"/wd 4201", -- Disable 'Nonstandard extension used: nameless struct/union'. Used for uniforms in the project.
			"/wd 4345", -- Disable 'An object of POD type constructed with an initializer of the form () will be default-initialized'. It's an obsolete warning.
		}
		linkoptions
		{
			"/ignore:4199", -- LNK4199: /DELAYLOAD:*.dll ignored; no imports found from *.dll
		}
		links
		{ -- this is needed only for testing with GLES2/3 on Windows with VS2008
			"DelayImp",
		}

	configuration { "vs*", "x32" }
		links
		{
			"psapi",
		}

	configuration { "vs2010" }
		linkoptions
		{ -- this is needed only for testing with GLES2/3 on Windows with VS201x
			"/DELAYLOAD:\"libEGL.dll\"",
			"/DELAYLOAD:\"libGLESv2.dll\"",
		}