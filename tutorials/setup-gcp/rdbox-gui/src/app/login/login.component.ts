import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { VerificationResultDialogComponent } from '../verification-result-dialog/verification-result-dialog.component';
import { VerificationService } from '../service/verification.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  public title: string = 'rdbox-gui';
  public authUrl: string = 'Now Loading...';
  public verificationCode: string = '';
  public notGrantGCP: boolean = true;
  private retLoginURL: object = {};

  constructor(private verificationService: VerificationService, private http: HttpClient, public dialog: MatDialog) {}

  ngOnInit() {
    this.http.get('/api/bootstrap/gcp/login/url'
    ).subscribe(
      json => {
        this.authUrl = json['url'];
        this.retLoginURL = json;
      },
      error => {
        alert('Response Error. Restart the service.')
      }
    );
  }

  grant(): void {
    this.notGrantGCP = false;
  }

  submit(): void {
    let ps: object = {};
    ps['token'] = this.verificationCode;
    ps['date'] = this.retLoginURL['date'];

    if (!this.notGrantGCP && this.verificationCode.length > 0) {
      this.http.post('/api/bootstrap/gcp/login/token', ps, {
        headers: new HttpHeaders({
          'Content-Type': 'application/json'
        })
      }).subscribe(
        json => {
          this.openSuccessDialog()
        },
        error => {
          alert(error.error.msg)
        }
      );
    }
  }

  openSuccessDialog(): void {
    const dialogRef = this.dialog.open(VerificationResultDialogComponent, {
      width: '400px',
      disableClose : true
    });
    dialogRef.afterClosed().subscribe(result => {
      return
    });
  }
}
