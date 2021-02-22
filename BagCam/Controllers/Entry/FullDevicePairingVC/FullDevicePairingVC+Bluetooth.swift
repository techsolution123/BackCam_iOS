//
//  FullDevicePairingVC+Bluetooth.swift
//  BagCam
//
//  Created by Kevin Shah on 22/02/21.
//

import CoreBluetooth

// MARK: - CBCentralManagerDelegate
extension FullDevicePairingVC: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("Bluetooth State: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else {
            return
        }
        print("Bluetooth Name:\(peripheral.name!)")
        if !self.arrCBPeripheral.contains(peripheral) {
            self.arrCBPeripheral.append(peripheral)
            DispatchQueue.main.async {
                self.arrDisplayCellType = [
                    .row([BagImageType.normal,
                          GeneralLabelInfoType.availableDevices,
                          GeneralLabelInfoType.selectBagCam]),
                    .devices(self.arrCBPeripheral)
                ]
                self.tableView.reloadData()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(#function)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("\(#function): \(error?.localizedDescription)")
    }
}
