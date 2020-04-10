import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { VerificationService } from '../service/verification.service';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class VerificationGuard implements CanActivate {

  constructor (private verificationService: VerificationService, private router: Router, private http: HttpClient) {}

  canActivate(
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
      return this.judgeLogInUser();
  }

  async judgeLogInUser(): Promise<boolean> {
    let responseData: {[index: string]: string}[] = await this.getCurrentUserInformation()
    if (responseData.length > 0) {
      return true
    } else {
      return false
    }
  }

  public getCurrentUserInformation(): Promise<any>{
    const result = this.http.get("/api/bootstrap/gcp/login/status").toPromise();
    return result;
  }
}
