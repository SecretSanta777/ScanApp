import AVFoundation

extension MainViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard let code = metadataObject.stringValue else { return }
        
        scannedCode = code
        
        let codeType = metadataObject.type
        scannedCodeType = getCodeTypeName(codeType)
        
        session.stopRunning()
        
        Task {
            await fetchDataFromScaned()
        }
        
    }
}
