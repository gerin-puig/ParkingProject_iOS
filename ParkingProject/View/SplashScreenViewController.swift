//
//  SplashScreenViewController.swift
//  ParkingProject
//
//  Created by Mayank Arya on 2021-05-12.
//
// Gerin Puig - 101343659
// Mayank Arya - 101300566

import SwiftUI


class SplashScreenViewController: UIViewController {

    let userDefaults = MaGeUserDefaults()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.navigationBar.isHidden = true
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                if(self.userDefaults.doRememberMe()){
                    guard let homeScreenVc = self.storyboard?.instantiateViewController(identifier:"TabBarController") as? UITabBarController else{
                        return
                    }
               
                    self.show(homeScreenVc, sender: (Any).self)

                }else{
                    guard let loginScreenVc = self.storyboard?.instantiateViewController(identifier: "LoginScreen") as? LoginViewController else{
                        return
                    }
                    self.show(loginScreenVc, sender: (Any).self)

                }
            }
        }
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

    }
