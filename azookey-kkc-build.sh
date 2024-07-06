runHook preBuild

local buildCores=1
if [ "${enableParallelBuilding-1}" ]; then
  buildCores="$NIX_BUILD_CORES"
fi

local flagsArray=(
  -j $buildCores
  -c "${swiftpmBuildConfig-release}"
  $swiftpmFlags "${swiftpmFlagsArray[@]}"
)

echoCmd 'build flags' "${flagsArray[@]}"
TERM=dumb swift build "${flagsArray[@]}"

runHook postBuild
