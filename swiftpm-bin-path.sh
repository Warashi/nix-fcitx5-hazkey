swiftpmBinPath() {
    local flagsArray=(
        -c "${swiftpmBuildConfig-release}"
        $swiftpmFlags "${swiftpmFlagsArray[@]}"
    )

    swift build --show-bin-path "${flagsArray[@]}"
}
