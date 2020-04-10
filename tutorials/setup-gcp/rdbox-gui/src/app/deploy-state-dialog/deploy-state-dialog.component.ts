import { Component, OnInit, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/common'; 
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Subject, Observable, interval, Subscription, EMPTY, of } from 'rxjs';
import { flatMap, repeatWhen, takeUntil, catchError, timeout } from 'rxjs/operators';

export interface DialogData {
  project: string;
  deployment: string;
  state: string;
}

@Component({
  selector: 'app-deploy-state-dialog',
  templateUrl: './deploy-state-dialog.component.html',
  styleUrls: ['./deploy-state-dialog.component.scss']
})
export class DeployStateDialogComponent implements OnInit {

  private subject = new Subject<any>();
  private data$ = this.subject.asObservable();
  public progress: {[index: string]: string[]} = {
    'done': [],
    'update': [],
    'error': [],
    'emsg': [],
    'status': ['0']
  };
  private subscription: Subscription;

  public title: string = 'Now Deploying...';
  public percent: number = 0;
  public doneMessage: string = '';
  public errMessage: string = '';
  public isSuccess: boolean = false;
  public isError: boolean = false;

  private readonly _stop = new Subject<void>();
  private readonly _start = new Subject<void>();

  constructor(
    public dialogRef: MatDialogRef<DeployStateDialogComponent>,
    private http: HttpClient,
    @Inject(MAT_DIALOG_DATA) public data: DialogData,
    @Inject(DOCUMENT) document) {}

  ngOnInit(): void {
    this._polling().subscribe(
      json => {
        this.subject.next(json);
      },
      error => {
        console.log(error)
      },
      () => {
        console.log('Complete')
        this.subject.next(this.progress);
      }
    );

    this.subscription = this.data$.subscribe(json => {
      this.progress = json;
      this.percent = parseInt(this.progress.status[0])
      if (this.percent > 0) {
        this.doneMessage = '';
        this.errMessage = '';
        for (let i = 0; i < this.progress.done.length; i++) {
          this.doneMessage += this.progress.done[i] + '...done' + '\n';
        }
        for (let i = 0; i < this.progress.emsg.length; i++) {
          this.errMessage += this.progress.emsg[i] + '\n';
        }
      }
      if (this.percent ===  100) {
        this.title = 'Successfully deployed!!';
        this.isSuccess = true;
      }
      if (this.progress.error.length > 0) {
        this.title = 'Failed deployed!!';
        this.isError = true;
      }
      let tareaDone: HTMLTextAreaElement =<HTMLTextAreaElement>document.getElementById('tarea-done');
      tareaDone.scrollTop = tareaDone.scrollHeight;
      let tareaErr: HTMLTextAreaElement =<HTMLTextAreaElement>document.getElementById('tarea-err');
      tareaErr.scrollTop = tareaErr.scrollHeight;
    });

    this.start_cycle();
  }

  private _polling(): Observable<any> {
    return interval(5000).pipe(
      flatMap(() => this.http.get('/api/bootstrap/gcp/deployment-manager/deployments/resources', {
        params: new HttpParams(
        ).set('project', this.data.project)
        .set('deployment', this.data.deployment)
      }).pipe(
        catchError(err => {
          return of(this.progress)
        })
      )),
      takeUntil(this._stop),
      repeatWhen(() => this._start),
      catchError(err => {
        console.log("Caught Error, Unsustainable!!")
        return EMPTY;
      })
    );
  }

  public onClickDone(): void {
    try {
      this.stop_cycle();
    } catch {}
    this.subject.complete();
    this.subscription.unsubscribe();
    this.data.state = 'SUCCESS'
    this.dialogRef.close(this.data.state);
  }

  public onClickBack(): void {
    try {
      this.stop_cycle();
    } catch {}
    this.subject.complete();
    this.subscription.unsubscribe();
    this.data.state = 'ERROR'
    this.dialogRef.close(this.data.state);
  }

  private start_cycle(): void {
    this._start.next();
  }
  private stop_cycle(): void {
    this._stop.next();
  }
}
